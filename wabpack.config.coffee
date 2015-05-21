webpack = require 'webpack'
path = require 'path'

bower_dir = path.join __dirname, '/bower_components'

module.exports = {
    context: __dirname
    cache: true
    watch: true
    devtool: "inline-source-map"

    devServer: {
        hot: true
        inline: true
        noInfo: true #  --no-info option
        # historyApiFallback: true
    }

    entry: {
        main: [
            'webpack-dev-server/client?localhost:8080'
            'webpack/hot/only-dev-server'
            './js/cjsx/main.cjsx'
        ]
    }

    resolve: {
        alias: {
          'bullet': path.join __dirname, '/js/cjsx/bullet.js'
        }
      }

    output: {
        path: path.join __dirname, 'js'
        publicPath : '/assets/'
        filename: "bundle.js"
#        chunkFilename: "[id].chunk.js"
        pathinfo: true
    }

    resolveLoader: {
        modulesDirectories: ['node_modules']
    }

    module: {
        loaders: [
            { test: /\.cjsx$/, loaders: ['react-hot', 'coffee-loader', 'cjsx-loader']}
            { test: /\.coffee$/, loader: 'coffee-loader' }
            { test: /\.styl$/, loader: 'style-loader!css-loader!stylus-loader' }
        ]
    }

    plugins: [
        new webpack.HotModuleReplacementPlugin()
        new webpack.NoErrorsPlugin()
    ]
}