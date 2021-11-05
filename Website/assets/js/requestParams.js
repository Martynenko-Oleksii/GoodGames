class RequestParams {
  constructor(method,
              url,
              body = null,
              responseType = "json",
              contentType = "application/json",
              stringify = true) {
    this.method = method;
    this.url = url;
    this.body = body;
    this.responseType = responseType;
    this.contentType = contentType;
    this.stringify = stringify;
  }
}