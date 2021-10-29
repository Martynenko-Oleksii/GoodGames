document.addEventListener("DOMContentLoaded", pageLoaded);

function pageLoaded() {
  const userId = Cookies.get("id");
  if (!userId) {
    console.log("Can`t get id from Cookies");
    return;
  }

  sendServerRequest(userId);


  function sendServerRequest(userId) {
    const requestUrl = "/api/sports/" + userId;

    ServerRequest.send("GET", requestUrl)
      .then(data => parseServerResponse(data))
      .catch(err => console.log(err));
  }

  function parseServerResponse(data) {
    console.log(data);
  }
}