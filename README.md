# librato-github-annotate

Add deployment annotation to Librato with your GitHub-flow.

## Usage

This app is designed to be used and deployed on Heroku.

Set the following ENV variables during deployment:

* `LIBRATO_EMAIL`
* `LIBRATO_API_KEY`
* `ANNOTATION_NAME`

Once you've done, you can add `/annotate/:source` as GitHub webhook with `deployment_status` event enabled.

## License

MIT License. See LICENSE for details.

Copyright (c) 2015 [Polydice, Inc.](http://polydice.com)