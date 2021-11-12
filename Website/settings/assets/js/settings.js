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
  document.querySelector(".change-password-button");

const sportKindContainerEl = document.querySelector(".sport-kind-container");

const saveSportKindsButtonEl =
  document.querySelector(".save-sport-kinds-button");


let favouriteSportKindsArr = [];
let allSportArr = [];


document.addEventListener("DOMContentLoaded", pageLoaded);

function pageLoaded() {
  updateAvatarInterface();
  updateFavouriteSportKinds();
  updateSportAllList();

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
        Cookies.set('avatarPath', data.avatarPath, { expires: 7, path: '/' });
        resetFileButtonEl.style.display = "inline-block";
        return;
      }

      changeAvatarButtonEl.innerHTML = "Додати аватар";
      avatarEl.src = "/assets/images/user-48.png";
      resetFileButtonEl.style.display = "none";
    })
    .catch(err => console.log(err));
}

function updateFavouriteSportKinds() {
  sendServerRequest();


  function sendServerRequest() {
    const userId = Cookies.get("id");
    if (!userId) {
      console.log("Can`t get id from Cookies");
      return;
    }

    const requestParams = new RequestParams();
    requestParams.url = "/api/sports/" + userId;

    ServerRequest.send(requestParams)
      .then(data => parseServerResponse(data))
      .catch(err => console.log(err));
  }

  function parseServerResponse(data) {
    if (!data || data.length === 0) {
      favouriteSportKindsArr = [];

      sportKindContainerEl.innerHTML =
      `<div class="ol-12 mt-4 pt-2">
          <div class="bg-white none_card">
              <div class="d-flex align-items-center" style="justify-content: center;">
                  <div style="margin-right: 15px;" class="icon text-center rounded-circle mr-5">
                      <img src="https://img.icons8.com/fluency/48/000000/plus-math.png"/>
                  </div>

                  <div class="content">
                      <h4 class="title mb-0">Ваш список підписок пустий.</h4>
                      <p class="text-muted mb-0">Підпишіться на види спорту якнайшвидше!</p>
                  </div>
              </div>
          </div>
      </div>`;
      return;
    }

    for (let sportKind of data) {
      favouriteSportKindsArr.push(sportKind);

      let sportKindEl = document.createElement("div");
      sportKindEl.classList.add("col-lg-6", "mt-4", "pt-2");

      sportKindEl.innerHTML =
        `
        <div class="col-lg-6 mt-4 pt-2" style="cursor: pointer;">
          <a class="text-dark">
            <div class="key-feature d-flex align-items-center p-3 bg-white rounded shadow">
              <div style="margin-right: 15px;" class="icon text-center rounded-circle mr-5">
                <ion-icon name="game-controller-outline"></ion-icon>
              </div>

              <div class="content">
                <h4 class="title mb-0">${sportKind.title}</h4>
                <p class="text-muted mb-0">{?} змаганнь</p>
              </div>
            </div>
          </a>
        </div>
        `;

      sportKindContainerEl.appendChild(sportKindEl);
    }
  }
}

function updateSportAllList(){
    sendServerRequest();

    function sendServerRequest() {
				const requestParams = new RequestParams();
        requestParams.url = "/api/sports/";

        ServerRequest.send(requestParams)
            .then(data => parseServerResponse(data))
            .catch(err => console.log(err));
    }

    function parseServerResponse(data) {
        if (data.length === 0) {
            allSportArr = [];
            return;
        }

        const SportWrapperEl = document.querySelector(".addStort");
			  SportWrapperEl.innerHTML = "";

        for (let SportInfo of data) {
            allSportArr.push({info: SportInfo, isFavouriteForUser: undefined});

            createSportElement(SportInfo);
        }
    }

    function createSportElement(SportInfo) {
      if (!SportInfo) {
          console.log("Нет видов спорта.");
          return;
      }

      const SportId = SportInfo.id;
      const SportTitle = SportInfo.title;
      const SportminCompetitorsCount = SportInfo.minCompetitorsCount;

      if (!SportId || !SportTitle) {
          console.log("Что-то пошло не так. Неравенство данных.");
          return;
      }

      const competitionsWrapperEl =
          document.querySelector(".addStort");

      competitionsWrapperEl.innerHTML +=
          `<div class="checkbox">
              <label class="checkbox-wrapper">
                  <input type="checkbox" class="checkbox-input" name="sport_${SportId}" id="sport_${SportId}" />
                  <span class="checkbox-tile">

                      <a class="text-dark">
                          <div class="key-feature2 d-flex align-items-center p-3">
                            <div style="margin-right: 15px;" class="icon text-center rounded-circle mr-5">
                              <ion-icon name="game-controller-outline"></ion-icon>
                            </div>
              
                            <div class="content">
                              <h4 class="title mb-0">${SportTitle}</h4>
                              <p class="text-muted mb-0">Кількість гравців: ${SportminCompetitorsCount}</p>
                            </div>
                          </div>
                      </a>

                  </span>
              </label>
          </div>`;

  }
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

    document.getElementById("error_photo").style.display = "block";
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
    updateAvatarInterface();
    document.getElementById("done_info").style.display = "block";
    document.getElementById("error_photo").style.display = "none";
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
    //alert("Пароль успішно змінено");
    document.getElementById("done_info").style.display = "block";
  }
}


function openSportKindsModalWindow() {
  document.getElementById('modal_edit').style.display = 'block';

  updateAllSportArrCheckedStatus();

  for (let allSportArrEl of allSportArr) {
    const sportId = allSportArrEl.info.id;
    const isSportFavouriteForUserStatus = allSportArrEl.isFavouriteForUser;

    const checkboxEl = document.querySelector("#sport_" + sportId);
    checkboxEl.checked = isSportFavouriteForUserStatus;
  }
}

function updateAllSportArrCheckedStatus() {
  for (let allSportArrEl of allSportArr) {
    const allSportArrElId = parseInt(allSportArrEl.info.id);
    allSportArrEl.isFavouriteForUser = false;

    for (let favouriteSportKindsArrEl of favouriteSportKindsArr) {
      const favouriteSportKindsArrElId = parseInt(favouriteSportKindsArrEl.id);
      if (allSportArrElId !== favouriteSportKindsArrElId) {
        continue;
      }

      allSportArrEl.isFavouriteForUser = true;
      break;
    }
  }
}


saveSportKindsButtonEl.addEventListener("click", () => saveSportKinds());

function saveSportKinds() {
  const userId = Cookies.get("id");
  if (!userId) {
    return;
  }

  let checkboxEls = document.querySelectorAll(".checkbox-input");
  for (let checkboxEl of checkboxEls) {
    const removeSymbolNumber = "sport_".length;
    const sportId = parseInt( checkboxEl.name.substr(removeSymbolNumber) );
    const sportCheckedStatus = checkboxEl.checked;

    let wasChanged = false;
    for (let allSportArrEl of allSportArr) {
      if (parseInt(allSportArrEl.info.id) !== sportId) {
        continue;
      }

      if (allSportArrEl.isFavouriteForUser !== sportCheckedStatus) {
        wasChanged = true;
      }
      break;
    }

    if (!wasChanged) {
      continue;
    }

    const requestParams = new RequestParams("POST");
    if (checkboxEl.checked) {
      requestParams.url = "/api/addsport/" + userId;
    } else {
      requestParams.url = "/api/deletesport/" + userId;
    }
    requestParams.body = { id: sportId };

    ServerRequest.send(requestParams)
      .then(data => {
        console.log(data);
        updateFavouriteSportKinds();
        updateSportAllList();
      })
      .catch(err => console.log(err));
  }

  document.querySelector("#modal_edit").style.display = "none";
}