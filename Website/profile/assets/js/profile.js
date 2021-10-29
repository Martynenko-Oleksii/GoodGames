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
    const sportKindBlock = document.querySelector(".sport-kind-block");
    if (!data || data.length === 0) {
      sportKindBlock.innerHTML = "Тут будуть ваші спортивні дисципліни";
      return;
    }

    for (let sportKind of data) {
      let sportKindEl = document.createElement("p");
      sportKindEl.className = "sport-kind";
      sportKindEl.innerHTML = sportKind;

      sportKindBlock.appendChild(sportKind);
    }
  }
}