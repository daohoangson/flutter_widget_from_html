import { NowRequest, NowResponse } from '@now/node'

export default (request: NowRequest, response: NowResponse) => {
  const { body: body1 } = request.body
  const { body: body2 } = request.query
  const body = body1 || body2
  if (!body) response.status(400).send('POST param `body` or include in query string to render.')

  const html = `
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width">
</head>
<body>${body}</body>
</html>
`

  response.status(200).send(html)
}
