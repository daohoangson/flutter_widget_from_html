# HtmlWidget companion api

## Supported features

### iframe

Some web services (e.g. Twitter) will not render properly if their embedded code is used as a data URI within a web view.
The iframe api will receive the HTML and render a proper web page to help with that. It supports both GET and POST request to accommodate large input.

#### GET request

```bash
curl https://api.flutter-widget-from-html.vercel.app/iframe.ts\?body=hello
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
curl https://api.flutter-widget-from-html.vercel.app/iframe.ts -d body=lorem+lipsum
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

Use `./tool/node.sh` to setup a `Node.js` container for development, don't forget to change the working directory into `./packages/api`.

Execute `npm install` to install the dependencies then `npm run dev`.

## Deployment

The repository has been pre-configured to deploy to `https://api.flutter-widget-from-html.vercel.app`, just do git push to any `api/*` branches.
