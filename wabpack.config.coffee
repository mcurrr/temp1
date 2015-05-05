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
            'webpack-dev-server/client?10.1.4.67:8080'
            'webpack/hot/only-dev-server'
            './js/cjsx/main.cjsx'
        ]

    resolve: {
        alias: {
          'bullet'     : path.join __dirname, '/js/bullet.js'
        }
      }

    output: {
        path: __dirname
        publicPath : 'http://10.1.4.67:8080/assets' #'/static/js/dist/'
        filename: "[name].bundle.js"
        chunkFilename: "[id].chunk.js"
        pathinfo: true
    }

    resolveLoader: {
        modulesDirectories: ['node_modules']
    }

    module: {
        loaders: [
            { test: /\.cjsx$/, loaders: ['react-hot', 'coffee-loader', 'cjsx-loader']}
            { test: /\.coffee$/, loader: 'coffee-loader' }
        ]
        noParse: [
            path.join __dirname, '/js/bullet.js',
            path.join __dirname, '/node_modules/react/react.js',
            path.join __dirname, '/node_modules/react/addons.js',
        ]
    }
    plugins: [
        new webpack.HotModuleReplacementPlugin()

        new webpack.optimize.OccurenceOrderPlugin true

        new webpack.optimize.CommonsChunkPlugin {
            name: "vendor"
            filename: "vendor.bundle.js"
            minChunks: Infinity
        }

        new webpack.ProvidePlugin {
           React : 'react/addons'
           $     : "jquery"
           'window.$'     : "jquery"
           jQuery: "jquery"
           _     : "lodash"
        }

        new webpack.optimize.DedupePlugin()
        new webpack.DefinePlugin {
            "process.env": {
                NODE_ENV: JSON.stringify "development"
            }
        }
    ]
}