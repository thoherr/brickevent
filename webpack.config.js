const path    = require("path")
const webpack = require("webpack")

const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const RemoveEmptyScriptsPlugin = require('webpack-remove-empty-scripts');

const mode = process.env.NODE_ENV === 'development' ? 'development' : 'production';

module.exports = {
  mode,
  entry: {
    application: [
      './app/javascript/application.js',
      './app/assets/stylesheets/application.scss',
    ],
  },
  module: {
    rules: [
        {
          test: /\.(js)$/,
          exclude: /node_modules/,
          use: ['babel-loader'],
        },
        {
           test: /\.(?:sa|sc|c)ss$/i,
           use: [MiniCssExtractPlugin.loader, 'css-loader', 'sass-loader'],
         },
    ],
  },
  resolve: {
    // Add additional file types
    extensions: ['.js', '.jsx', '.scss', '.css'],
  },
  output: {
    filename: "[name].js",
    chunkFilename: "[name]-[contenthash].digested.js",
    sourceMapFilename: "[file]-[fullhash].map",
    path: path.resolve(__dirname, '..', '..', 'app/assets/builds'),
    hashFunction: "sha256",
    hashDigestLength: 64,
  },
  plugins: [
    new RemoveEmptyScriptsPlugin(),
    new MiniCssExtractPlugin(),
    new webpack.optimize.LimitChunkCountPlugin({
      maxChunks: 1
    })
  ],
  optimization: {
    moduleIds: 'deterministic',
  }
}
