# Controller Test Coverage Gap Analysis - BrickEvent

## Executive Summary

This analysis identifies the 5 controllers with the lowest test coverage in the BrickEvent Rails 7.2 application. The current coverage ranges from 59% to 88%, with significant gaps in error handling, edge cases, and specific action methods.

---

## 1. EVENTS CONTROLLER - 59.02% Coverage (36/61 executable lines)

**File:** `/Users/thomas/Development/private/brickevent/app/controllers/events_controller.rb`

### Current Coverage
- **Executed lines:** 36/61
- **Uncovered lines:** 25 total
- **Line numbers missing:** 31, 35-41, 43-44, 51-57, 59-60, 67, 69-70, 82, 92, 107

### Missing Test Coverage by Action

#### 1. `open_voting` action (Lines 34-48)
**Status:** Not tested
**Type:** Feature flag - voting control

**Missing scenarios:**
- Setting voting scope when @event is nil (error path - line 35)
- Successful save response format as JSON (line 41)
- Failed save error handling (lines 43-44)

**Suggested tests to add:**
```ruby
test "should open voting for event" do
  @user = users(:thoherr)  # admin
  @user.confirm
  sign_in @user
  event = events(:three)
  post :open_voting, params: { id: event.id, voting_scope: "category1" }
  assert_redirected_to votes_event_path(event)
  assert_equal t('voting_started'), flash[:notice]
end

test "should return json when opening voting" do
  @user = users(:thoherr)
  @user.confirm
  sign_in @user
  event = events(:three)
  post :open_voting, params: { id: event.id, voting_scope: "category1", format: :json }
  assert_response :success
  assert_equal "category1", JSON.parse(response.body)
end

test "should handle voting scope save failure" do
  # Test when @event.save fails
end
```

#### 2. `close_voting` action (Lines 50-64)
**Status:** Not tested
**Type:** Feature flag - voting control

**Missing scenarios:**
- Same as open_voting: nil event handling, JSON response, save failures

**Suggested tests to add:**
```ruby
test "should close voting for event" do
  @user = users(:thoherr)
  @user.confirm
  sign_in @user
  event = events(:three)
  post :close_voting, params: { id: event.id }
  assert_redirected_to votes_event_path(event)
  assert_equal t('voting_stopped'), flash[:notice]
end
```

#### 3. `voting_posters` action (Lines 66-74)
**Status:** Not tested
**Type:** File generation - PDF zip creation

**Missing scenarios:**
- ZIP file generation and download (lines 69-73)
- Proper content type and filename handling

**Suggested tests to add:**
```ruby
test "should download voting posters zip" do
  @user = users(:thoherr)
  @user.confirm
  sign_in @user
  event = events(:three)
  get :voting_posters, params: { id: event.id }
  assert_response :success
  assert_equal 'application/zip', response.content_type
  assert response.body.start_with?("PK")  # ZIP file magic number
end
```

#### 4. `attendees_as_csv` action (Lines 76-84)
**Status:** Partially tested (only success case)
**Type:** Data export - CSV generation

**Missing scenarios:**
- @event is nil handling (lines 81-82)
- Redirect when unauthorized (line 82)

**Suggested tests to add:**
```ruby
test "should handle missing event when getting attendees as csv" do
  @user = users(:thoherr)
  @user.confirm
  sign_in @user
  # Request non-existent event or from unauthorized access
  assert_raise do
    get :attendees_as_csv, params: { id: 99999 }
  end
end
```

#### 5. `exhibits_as_csv` action (Lines 86-94)
**Status:** Partially tested (only success case)
**Type:** Data export - CSV generation

**Missing scenarios:**
- Same as attendees_as_csv: nil event and redirect handling

#### 6. `load_event` private method (Lines 113-121)
**Status:** Not explicitly tested
**Type:** Authorization - prevent unauthorized access

**Missing scenarios:**
- Unauthorized user attempting to load event (line 120)
- Proper exception raising when authorization fails

**Suggested tests to add:**
```ruby
test "should raise when unauthorized user tries to access event" do
  user = users(:one)  # non-admin, non-manager
  user.confirm
  sign_in user
  assert_raise do
    get :show, params: { id: events(:three).id }
  end
end
```

---

## 2. ATTENDANCES CONTROLLER - 65.22% Coverage (45/69 executable lines)

**File:** `/Users/thomas/Development/private/brickevent/app/controllers/attendances_controller.rb`

### Current Coverage
- **Executed lines:** 45/69
- **Uncovered lines:** 24 total
- **Line numbers missing:** 52-53, 68-69, 77-78, 80-83, 101-102

### Missing Test Coverage by Action

#### 1. `create` action (Lines 44-56)
**Status:** Tested successfully, but error path missing
**Type:** CRUD - create record

**Missing scenarios:**
- JSON format response on error (line 53)
- HTML render when save fails (line 52)

**Suggested tests to add:**
```ruby
test "should handle failed attendance creation" do
  post :create, params: { 
    attendance: { user_id: nil, event_id: nil }
  }
  assert_response :unprocessable_entity
  assert_template :new
end

test "should return json error on failed create" do
  post :create, params: { 
    attendance: { user_id: nil, event_id: nil },
    format: :json
  }
  assert_response :unprocessable_entity
  assert_equal 'application/json', response.content_type
end
```

#### 2. `approve` action (Lines 58-73)
**Status:** Tested for authorized users only
**Type:** Authorization + state change

**Missing scenarios:**
- @attendance is nil (line 60)
- Authorization failure (line 61)
- Failed save error responses (lines 68-69)
- JSON format error handling (line 69)

**Suggested tests to add:**
```ruby
test "should handle approve when attendance is nil" do
  # Create non-existent ID scenario
  assert_raise do
    post :approve, params: { id: 99999 }
  end
end

test "should return json error when approve fails" do
  @user = users(:thoherr)
  @user.confirm
  sign_in @user
  post :approve, params: { id: @attendance.id, format: :json }
  # Test JSON error response
end
```

#### 3. `copy_exhibits` action (Lines 75-89)
**Status:** Tested successfully, but error path missing
**Type:** CRUD - copy operation

**Missing scenarios:**
- Failed copy response (lines 85-86)
- JSON format error handling (line 86)

**Suggested tests to add:**
```ruby
test "should handle failed copy exhibits" do
  post :copy_exhibits, params: { 
    id: @attendance.id, 
    other_attendance_id: 99999 
  }
  # Test error handling
end
```

#### 4. `add_former_exhibit` action (Lines 91-105)
**Status:** Not tested
**Type:** CRUD - add operation

**Missing scenarios:**
- Successful addition (lines 97-99)
- Failed addition (lines 101-102)
- Authorization check

**Suggested tests to add:**
```ruby
test "should add former exhibit" do
  post :add_former_exhibit, params: {
    id: @attendance.id,
    former_exhibit_id: exhibits(:one).id
  }
  assert_redirected_to attendances_url
  assert_equal 'Eintrag wurde kopiert.', flash[:notice]
end

test "should handle failed former exhibit addition" do
  # Test error path
end
```

#### 5. `former_exhibits` action (Lines 107-116)
**Status:** Stub only (line 110-111 TODO comment)
**Type:** View-only action

**Missing scenarios:**
- Actual exhibit retrieval and display
- JSON format response

**Suggested tests to add:**
```ruby
test "should get former exhibits" do
  get :former_exhibits, params: { id: @attendance.id }
  assert_response :success
end

test "should return json for former exhibits" do
  get :former_exhibits, params: { id: @attendance.id, format: :json }
  assert_response :success
  assert_equal 'application/json', response.content_type
end
```

---

## 3. ATTENDEES CONTROLLER - 71.43% Coverage (35/49 executable lines)

**File:** `/Users/thomas/Development/private/brickevent/app/controllers/attendees_controller.rb`

### Current Coverage
- **Executed lines:** 35/49
- **Uncovered lines:** 14 total
- **Line numbers missing:** 16-26, 47-48, 63-64

### Missing Test Coverage by Action

#### 1. `approve` action (Lines 15-30)
**Status:** Not tested
**Type:** Authorization + state change

**Missing scenarios:**
- Authorization check before approval (line 17)
- Successful toggle (lines 19-28)
- Failed save (lines 26-27)
- JSON error response (line 26)

**Suggested tests to add:**
```ruby
test "should approve attendee when authorized" do
  @user = users(:thoherr)  # admin
  @user.confirm
  sign_in @user
  attendee = attendees(:one)
  post :approve, params: { id: attendee.id }
  assert_redirected_to event_path(attendee.event)
  assert_equal t('attendee_confirmation_changed'), flash[:notice]
  assert !attendee.reload.is_approved
end

test "should deny approval when not authorized" do
  attendee = attendees(:one)
  assert_raise do
    post :approve, params: { id: attendee.id }
  end
end

test "should handle failed approve save" do
  # Test when save fails
end
```

#### 2. `create` action (Lines 39-51)
**Status:** Tested successfully, but error path missing
**Type:** CRUD - create record

**Missing scenarios:**
- Failed creation error handling (lines 47-48)
- JSON error response (line 48)

**Suggested tests to add:**
```ruby
test "should handle failed attendee creation" do
  post :create, params: {
    attendee: { attendance_id: nil }  # Required field missing
  }
  assert_response :unprocessable_entity
  assert_template :new
end

test "should return json error on failed create" do
  post :create, params: {
    attendee: { attendance_id: nil },
    format: :json
  }
  assert_response :unprocessable_entity
end
```

#### 3. `update` action (Lines 55-67)
**Status:** Tested successfully, but error path missing
**Type:** CRUD - update record

**Missing scenarios:**
- Failed update error handling (lines 63-64)
- JSON error response (line 64)

**Suggested tests to add:**
```ruby
test "should handle failed attendee update" do
  @user = users(:two)
  @user.confirm
  sign_in @user
  put :update, params: {
    id: @attendee.to_param,
    attendee: { attendance_id: nil }
  }
  assert_template :edit
end

test "should return json error on failed update" do
  put :update, params: {
    id: @attendee.to_param,
    attendee: { attendance_id: nil },
    format: :json
  }
  assert_response :unprocessable_entity
end
```

---

## 4. EXHIBITS CONTROLLER - 83.02% Coverage (44/53 executable lines)

**File:** `/Users/thomas/Development/private/brickevent/app/controllers/exhibits_controller.rb`

### Current Coverage
- **Executed lines:** 44/53
- **Uncovered lines:** 9 total
- **Line numbers missing:** 28-29, 50-51, 66-67, 86-89

### Missing Test Coverage by Action

#### 1. `approve` action (Lines 18-33)
**Status:** Tested for successful cases only
**Type:** Authorization + state change

**Missing scenarios:**
- @exhibit is nil (line 20)
- Failed save error handling (lines 28-29)
- JSON error response (line 29)

**Suggested tests to add:**
```ruby
test "should handle failed exhibit approval" do
  @user = users(:thoherr)
  @user.confirm
  sign_in @user
  # Mock save failure or use invalid data
  # Test error path
end

test "should return json error on failed approval" do
  @user = users(:thoherr)
  @user.confirm
  sign_in @user
  post :approve, params: {
    id: @exhibit.id,
    format: :json
  }
  # Test JSON error response
end
```

#### 2. `create` action (Lines 42-54)
**Status:** Tested successfully, but error path missing
**Type:** CRUD - create record

**Missing scenarios:**
- Failed creation error handling (lines 50-51)
- JSON error response (line 51)

**Suggested tests to add:**
```ruby
test "should handle failed exhibit creation" do
  post :create, params: {
    exhibit: { attendance_id: nil, name: "" }
  }
  assert_response :unprocessable_entity
  assert_template :new
end

test "should return json error on failed create" do
  post :create, params: {
    exhibit: { attendance_id: nil, name: "" },
    format: :json
  }
  assert_response :unprocessable_entity
end
```

#### 3. `update` action (Lines 58-70)
**Status:** Tested successfully, but error path missing
**Type:** CRUD - update record

**Missing scenarios:**
- Failed update error handling (lines 66-67)
- JSON error response (line 67)

**Suggested tests to add:**
```ruby
test "should handle failed exhibit update" do
  user = users(:two)
  user.confirm
  sign_in user
  put :update, params: {
    id: @exhibit.to_param,
    exhibit: { name: "" }  # Required field empty
  }
  assert_template :edit
end

test "should return json error on failed update" do
  put :update, params: {
    id: @exhibit.to_param,
    exhibit: { name: "" },
    format: :json
  }
  assert_response :unprocessable_entity
end
```

#### 4. `voting_poster` action (Lines 85-90)
**Status:** Not tested
**Type:** File generation - PDF creation

**Missing scenarios:**
- PDF file generation and download
- Proper content type handling
- File serving

**Suggested tests to add:**
```ruby
test "should download voting poster pdf" do
  get :voting_poster, params: { id: @exhibit.id }
  assert_response :success
  assert_equal 'application/pdf', response.content_type
  assert response.body.start_with?("%PDF")  # PDF magic number
end

test "should handle unauthorized voting poster access" do
  user = users(:three)
  user.confirm
  sign_in user
  assert_raise do
    get :voting_poster, params: { id: @exhibit.id }
  end
end
```

---

## 5. USERS CONTROLLER - 88.24% Coverage (15/17 executable lines)

**File:** `/Users/thomas/Development/private/brickevent/app/controllers/users_controller.rb`

### Current Coverage
- **Executed lines:** 15/17
- **Uncovered lines:** 2 total
- **Line numbers missing:** 18-19

### Missing Test Coverage by Action

#### 1. `update` action (Lines 10-22)
**Status:** Tested successfully, but error path missing
**Type:** CRUD - update record

**Missing scenarios:**
- Failed update error handling (lines 18-19)
- JSON error response (line 19)

**Suggested tests to add:**
```ruby
test "should handle failed user update" do
  user = users(:one)
  user.confirm
  sign_in user
  put :update, params: {
    id: user.to_param,
    user: { email: "" }  # Invalid - required field
  }
  assert_response :unprocessable_entity
  assert_template :edit
end

test "should return json error on failed update" do
  user = users(:one)
  user.confirm
  sign_in user
  put :update, params: {
    id: user.to_param,
    user: { email: "" },
    format: :json
  }
  assert_response :unprocessable_entity
end
```

---

## Common Patterns in Missing Coverage

1. **Error Path Testing (Most Common):** All controllers lack tests for save/update failures, which should return error responses
2. **JSON Format Responses:** Most controllers don't test their JSON error paths (`respond_to` blocks with error handling)
3. **Authorization Edge Cases:** Some controllers don't test when authorization objects don't exist or are nil
4. **File Operations:** Voting posters and CSV exports lack validation of file generation and content types
5. **State Change Operations:** Approve/toggle actions lack comprehensive testing of edge cases

---

## Recommended Testing Priority

### High Priority (Most Impact)
1. **Events Controller:** Add tests for `open_voting`, `close_voting`, and `voting_posters` (affects 3 major features)
2. **Error path testing for all controllers:** Most common missing pattern
3. **JSON format responses:** Affects API consumers

### Medium Priority
1. **Attendances Controller:** `add_former_exhibit` and `former_exhibits` (complex feature)
2. **Attendees Controller:** `approve` action (authorization-critical)
3. **Authorization edge cases:** When objects don't exist

### Low Priority
1. **Trivial file handling tests** once infrastructure is in place

---

## Summary Statistics

| Controller | Coverage | Lines Tested | Lines Missing | Priority Issues |
|-----------|----------|--------------|----------------|-----------------|
| Events | 59.02% | 36/61 | 25 | Voting features, CSV export errors |
| Attendances | 65.22% | 45/69 | 24 | Former exhibits feature, error paths |
| Attendees | 71.43% | 35/49 | 14 | Approve action, error paths |
| Exhibits | 83.02% | 44/53 | 9 | Voting poster, approve errors |
| Users | 88.24% | 15/17 | 2 | Update error path |
