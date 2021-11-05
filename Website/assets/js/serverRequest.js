class ServerRequest {
    static send(method,
                url,
                body = null,
                responseType = "json",
                contentType = "application/json",
                stringify = true) {
        return new Promise((resolve, reject) => {
            const xhr = new XMLHttpRequest();
            xhr.open(method, url);

            xhr.responseType = responseType;

            if (contentType) {
                xhr.setRequestHeader("Content-Type", contentType);
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

            if (stringify) {
                body = JSON.stringify(body);
            }

            xhr.send(body);
        });
    }
}


/* GET request example
const requestUrl = "https://jsonplaceholder.typicode.com/users";

ServerRequest.send("GET", requestUrl)
  .then(data => console.log(data))
  .catch(err => console.log(err));
*/


/* POST request example
const requestUrl = "https://jsonplaceholder.typicode.com/users";

const body = {
  name: "Vladyslav",
  age: 18
}

ServerRequest.send("POST", requestUrl, body)
  .then(data => console.log(data))
  .catch(err => console.log(err));
*/
