class ServerRequest {
  static send(method, url, body = null) {
    return new Promise((resolve, reject) => {
      const xhr = new XMLHttpRequest();
      xhr.open(method, url);

      xhr.responseType = "json";
      xhr.setRequestHeader("Content-Type", "application/json");

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

      xhr.send(JSON.stringify(body));
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
