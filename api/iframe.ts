import { NowRequest, NowResponse } from '@now/node'

export default (request: NowRequest, response: NowResponse) => {
  const { body } = request.body || request.query
  if (!body) {
    return response.status(400).send('POST param `body` or include in query string to render.')
  }
  
  const escaped = body.replace(/&/g, '&amp;')
    .replace(/"/g, '&quot;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')

  const html = `
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width">
</head>
<body>
  <pre class="source">${escaped}</pre>
  <div class="render">${body}</div>
</body>
</html>
`

  return response.status(200).send(html)
}
