class ServerRequest {
    static send(requestParams) {
        return new Promise((resolve, reject) => {
            const xhr = new XMLHttpRequest();
            xhr.open(requestParams.method, requestParams.url);
            xhr.responseType = requestParams.responseType;
            if (requestParams.contentType) {
                xhr.setRequestHeader("Content-Type", requestParams.contentType);
            }

            xhr.onload = () => {
                if (xhr.status >= 400) {
                    reject(xhr.response)
                } else {
                    resolve(xhr.response);
                }
            }

            xhr.onerror = () => {
                reject(xhr.response);
            }

            if (requestParams.stringify) {
                requestParams.body = JSON.stringify(requestParams.body);
            }

            xhr.send(requestParams.body);
        });
    }
}
