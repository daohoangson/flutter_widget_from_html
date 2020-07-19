# HtmlWidget companion api

## Features

### iframe

Some web services (e.g. Twitter) will not render properly if their embedded code is used as a data URI within a web view.
The iframe api will receive the HTML and render a proper web page to help with that. It supports both GET and POST request to accommodate large input.

#### GET request

```bash
curl https://html-widget-api.now.sh/iframe.ts\?body=hello
```

Output:

```html
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width">
</head>
<body>hello</body>
</html>
```

#### POST request

```bash
curl https://html-widget-api.now.sh/iframe.ts -d body=lorem+lipsum
```

Output

```html
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width">
</head>
<body>lorem lipsum</body>
</html>
```

## Development

Use `./tool/node.sh` to setup a `Node.js` container for development, don't forget to change the working directory into `./api`.

Execute `npm install` to install the dependencies then `npm run dev`.

## Deployment

The repository has been configured to deploy to `vercel.app` automatically upon changes within `./api`. If it's merged into `master`, it'll be deployed to https://html-widget-api.now.sh.
