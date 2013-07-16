######################################################################
# puppet provisioning module for ssh_keys
# (c) 2013 42ways UG, teleteach GmbH

class sshkeys (
    $destusers          = [ 'root' ]
 )
{
    # this is a bit tricky
    # we define a resource and create an instance for every destination user, stating the user name in the title
    # this is the poor puppet user for loop....
    # see http://stackoverflow.com/questions/6399922/are-there-iterators-and-loops-in-puppet
    # the resource name has to be unique, so we combine unser and destuser
    define ssh_keys_for_user {
        ssh_authorized_key { "thomas_$title" :
            type => 'ssh-dss',
            key => "AAAAB3NzaC1kc3MAAAEBAMEQn8/DDwx2TPCwmdr0IzdB7lENFCYAF8HTawTLGUGA0QCoqxUGJaV3cH65jNP/g+ndo3BHdzuIT2NS5BSo+b/hQ/rxh+u8xtxaPYi9so9SaBhl3s1eP2sOgd2aJhSYqDaJ4r7ihQ03MGuLcEs8vHLmKpMHUagPrZc4ZqePwykZ7oyzPzKcat/gTZAhhZYn9qQhua2lBNYqTk36iRgIC7Iem+yJL1iR/uIIjYVclnk3j0F4t2KwzAZz2K7v6C9eYat+TflVKKuDhlf6s0now1FjKkoUtwwmWwdbT7n9h49jgn3lkJbtwE2XSo1WZZHXMmqVthbtDzXZqN7PuVw8Eb0AAAAVAKRsgwY5f4UVoi7agJC74wTBlrAHAAABAGwC+uLklnvkyWtIW/LEBwnfJQ0a7XncBSp+SxmzmMLU0mbXiKUyfmkZi3JLiS/2Y1Qo1cJG7/4Ql9MTaOSXjNOk9x8Ke9U1QpY7Ht1o5e7Z5pe2k/Au/wHhbgisD7bIrsTR2dW6V1K5kIzltJ1hXE4HdOuuV0vKsYBum7tjo8X3cNsQVn9eZojEGEW7h0tc5LOGp4hxUP+dfArBgwG5Rbn7YOn75l6Vl9Q8KwGN592uGA/vTIMmmXvVSep582Zh/il46Mrye5c1pWwoqxFEcEtOTBhUEe0x07tow0wWOTEhIBECV2Qh8+eBb0Xo8AGnzRns+Vp4CnO1mqHacAp0N6IAAAEBALNCMYLiEP7UEubRk7xGpDojYC1c7M5asZgLmGaykw9ITCtolpvijYpHecovH2/kv0M2RWdnVTTerY330dCDE7LFbMROkgvC9RekKk1029ps92NEtXLecCzZicTMeA1w5ieQxbakF8c7KAo/qkHmsrJ1VNjlkXBmONLoh1fKQ7Bv5arhvvuKkHBPHCC2UmcZFyjCwfCLZ8GADHMKuIjcRGqWUCTjT9WDhWuXEts2ZkLwbxxnGVDKz2RdnOl7tSSlRDdOe/3VDB5lUG/XcP4w74I7NnpdnQQ9KZJFS6Evk5uJhKVHNP1gMOiDFZJV/VCD3SzYBjfBbK4dZMNYEHl2NHc=",
            user => $title
        }
    }

    ssh_keys_for_user { $destusers : }
}
