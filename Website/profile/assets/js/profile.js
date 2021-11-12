const subscriptionStatusEl = document.querySelector(".subscription-status");
const subscriptionTermEl = document.querySelector(".subscription-term");
const buySubscriptionButtonEl =
  document.querySelector(".buy-subscription-button");

document.addEventListener("DOMContentLoaded", pageLoaded);
document.querySelector(".liq-pay-form__button").addEventListener("click", () => {
  getSubscriptionRequest();
})

function pageLoaded() {
  const userId = Cookies.get("id");
  if (!userId) {
    console.log("Can`t get id from Cookies");
    return;
  }

  updateSubscriptionInterface();
}


function getSubscriptionRequest() {
  const userId = Cookies.get("id");
  if (!userId) {
    console.log("Can`t get id from Cookies");
    return;
  }

  const requestParams = new RequestParams();
  requestParams.url = "/api/subs/" + userId;

  ServerRequest.send(requestParams)
    .then(data => updateSubscriptionInterface())
    .catch(err => console.log(err));
}


function updateSubscriptionInterface() {
  const userId = Cookies.get("id");
  if (!userId) {
    console.log("Can`t get id from Cookies");
    return;
  }

  const requestParams = new RequestParams();
  requestParams.url = "/api/users/" + userId;

  ServerRequest.send(requestParams)
    .then(data => {
      const subscriptionInfo = data.subscription;

      if (!subscriptionInfo) {
        subscriptionStatusEl.innerHTML = "Звичайна";
        subscriptionTermEl.style.display = "none";
        buySubscriptionButtonEl.style.display = "block";
        return;
      }

      const dateString = new Date(subscriptionInfo.end).toLocaleDateString();

      subscriptionStatusEl.innerHTML = "GoodGames Преміум";
      subscriptionTermEl.style.display = "block";
      subscriptionTermEl.innerHTML = "до " + dateString;
      buySubscriptionButtonEl.style.display = "none";
    })
    .catch(err => console.log(err));
}