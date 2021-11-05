const loginInputEl = document.querySelector(".login-input");
const emailInputEl = document.querySelector(".email-input");

const changeProfileInfoButtonEl =
  document.querySelector(".change-profile-info-button");


document.addEventListener("DOMContentLoaded", pageLoaded);

function pageLoaded() {
  const oldLogin = Cookies.get("login");
  const oldEmail = Cookies.get("email");

  loginInputEl.value = oldLogin;
  emailInputEl.value = oldEmail;
}


changeProfileInfoButtonEl.addEventListener("click", () => changeProfileInfo());

function changeProfileInfo() {
  const userId = Cookies.get("id");
  if (!userId) {
    console.log("Can`t get id from Cookies");
    return;
  }


  sendLoginChangeRequest();
  sendEmailChangeRequest();

  function sendLoginChangeRequest() {
    const requestUrl = "/api/users/change/login";

    const body = {
      id: userId,
      login: loginInputEl.value,
    }

    ServerRequest.send("POST", requestUrl, body)
      .then(data => changeLocalLogin(data.login))
      .catch(err => console.log(err));
  }

  function sendEmailChangeRequest() {
    const requestUrl = "/api/users/change/email";

    const body = {
      id: userId,
      email: emailInputEl.value,
    }

    ServerRequest.send("POST", requestUrl, body)
      .then(data => changeLocalEmail(data.email))
      .catch(err => console.log(err));
  }

  function changeLocalLogin(newLogin) {
    Cookies.set("login", newLogin);
  }

  function changeLocalEmail(newEmail) {
    Cookies.set("email", newEmail);
  }
}