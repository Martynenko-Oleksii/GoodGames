const avatarEl = document.querySelector(".avatar");
const avatarInputEl = document.querySelector(".avatar-input");
const changeAvatarButtonEl = document.querySelector(".change-avatar-button");
const resetFileButtonEl = document.querySelector(".reset-file-button");
const loginInputEl = document.querySelector(".login-input");
const emailInputEl = document.querySelector(".email-input");
const changeProfileInfoButtonEl =
  document.querySelector(".change-profile-info-button");
const passwordInputEl = document.querySelector(".password-input");
const changePasswordButtonEl =
  document.querySelector(".change-password-button")


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

  const requestParams = new RequestParams();
  requestParams.url = "/api/users/" + userId;

  ServerRequest.send(requestParams)
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
  document.getElementById("error_main").style.display = "none";
  const userId = Cookies.get("id");
  if (!userId) {
    console.log("Can`t get id from Cookies");
    return;
  }


  sendAvatarChangeRequest();
  sendLoginChangeRequest();
  sendEmailChangeRequest();


  function sendAvatarChangeRequest() {
    let file = avatarInputEl.files[0];

    if (!file) {
      return;
    }

    let formData = new FormData();
    formData.append("image", file);

    const requestParams = new RequestParams("POST");
    requestParams.url = "/api/users/change/image/" + userId;
    requestParams.body = formData;
    requestParams.responseType = "text";
    requestParams.contentType = "";
    requestParams.stringify = false;

    ServerRequest.send(requestParams)
      .then(data => changeLocalAvatar())
      .catch(err => console.log(err));
  }

  function sendLoginChangeRequest() {
    if (loginInputEl.value === Cookies.get("login")) {
      return;
    }

    if(loginInputEl.value.length > 4){
      const requestParams = new RequestParams("POST");
      requestParams.url = "/api/users/change/login";
      requestParams.body = {
        id: userId,
        login: loginInputEl.value,
      }
  
      ServerRequest.send(requestParams)
        .then(data => changeLocalLogin(data.login))
        .catch(err => console.log(err));
    }else{
      document.getElementById("error_main").textContent = "Короткий нікнейм.";
      document.getElementById("error_main").style.display = "block";
      return;
    }
    
  }

  function sendEmailChangeRequest() {
    if (emailInputEl.value === Cookies.get("email")) {
      return;
    }

    //Валидация почты
    var re = /[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/;
    if (re.test(String(emailInputEl.value).toLowerCase())) {
        //Ок
        const requestParams = new RequestParams("POST");
        requestParams.url = "/api/users/change/email";
        requestParams.body = {
          id: userId,
          email: emailInputEl.value,
        }

        ServerRequest.send(requestParams)
          .then(data => changeLocalEmail(data.email))
          .catch(err => console.log(err));
    } else {
        if (emailInputEl.value.length === 0) {
            document.getElementById("error_main").textContent = "Введіть пошту.";
            document.getElementById("error_main").style.display = "block";
            return;
        } else {
            document.getElementById("error_main").textContent = "Невірний адрес пошти.";
            document.getElementById("error_main").style.display = "block";
            return;
        }
        return;
    }

  }


  function changeLocalLogin(newLogin) {
    Cookies.set("login", newLogin);
    document.getElementById("done_info").style.display = "block";
    //alert("Логін успішно змінено");
  }

  function changeLocalEmail(newEmail) {
    Cookies.set("email", newEmail);
    document.getElementById("done_info").style.display = "block";
    //alert("Пошту успішно змінено");
  }

  function changeLocalAvatar() {
    document.getElementById("done_info").style.display = "block";
    //alert("Аватар успішно змінено");
  }
}


changePasswordButtonEl.addEventListener("click", () => changePassword());

function changePassword() {
  document.getElementById("error_pass").style.display = "none";

  const userId = Cookies.get("id");
  if (!userId) {
    console.log("Can`t get id from Cookies");
    return;
  }


  var rep = /^[a-zA-Z0-9]+$/;
  if (rep.test(String(passwordInputEl.value).toLowerCase())) {
      if (passwordInputEl.value.length === 0) {
          document.getElementById("error_pass").textContent = "Введіть пароль.";
          document.getElementById("error_pass").style.display = "block";
      } else {
          if (passwordInputEl.value.length < 8) {
              document.getElementById("error_pass").textContent = "Мінімум 8 символів.";
              document.getElementById("error_pass").style.display = "block";
          } else {
              sendPasswordChangeRequest();
          }
      }
  } else {
      if (passwordInputEl.value.length === 0) {
          document.getElementById("error_pass").textContent = "Введіть пароль.";
          return;
      } else {
          document.getElementById("error_pass").textContent = "Тільки латинськи літери";
          return;
      }
      return;
  }
  
  function sendPasswordChangeRequest() {
    if (!passwordInputEl.value) {
      return;
    }

    const requestParams = new RequestParams("POST");
    requestParams.url = "/api/users/change/password";
    requestParams.body = {
      id: userId,
      password: passwordInputEl.value,
    }

    ServerRequest.send(requestParams)
      .then(data => getPasswordChangeResponse())
      .catch(err => console.log(err));
  }

  function getPasswordChangeResponse() {
    alert("Пароль успішно змінено");
  }
}