const avatarEl = document.querySelector(".avatar");
const changeAvatarButtonEl = document.querySelector(".change-avatar-button");
const resetFileButtonEl = document.querySelector(".reset-file-button");
const loginInputEl = document.querySelector(".login-input");
const emailInputEl = document.querySelector(".email-input");
const changeProfileInfoButtonEl =
  document.querySelector(".change-profile-info-button");


document.addEventListener("DOMContentLoaded", pageLoaded);

function pageLoaded() {
  updateAvatarInterface();

  const oldLogin = Cookies.get("login");
  const oldEmail = Cookies.get("email");

  loginInputEl.value = oldLogin;
  emailInputEl.value = oldEmail;
}

function updateAvatarInterface() {
  const userId = Cookies.get("id");
  if (!userId) {
    console.log("Can`t get id from Cookies");
    return;
  }

  ServerRequest.send("GET", "/api/users/" + userId)
    .then(data => {
      const avatarPath = data.avatarPath;

      if (avatarPath) {
        changeAvatarButtonEl.innerHTML = "Змінити аватар";
        avatarEl.src = avatarPath;
        resetFileButtonEl.style.display = "inline-block";
        return;
      }

      changeAvatarButtonEl.innerHTML = "Додати аватар";
      avatarEl.src = "/assets/images/user-48.png";
      resetFileButtonEl.style.display = "none";
    })
    .catch(err => console.log(err));
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