const newsWrapperEl = document.querySelector(".news-slider__wrp");

document.addEventListener("DOMContentLoaded", getNewsFromServer);

function getNewsFromServer() {
  sendServerRequest();

  function sendServerRequest() {
    const requestParams = new RequestParams();
    requestParams.url = "/api/news";
    ServerRequest.send(requestParams)
      .then(data => parseServerResponse(data))
      .catch(err => console.log(err));
  }

  function parseServerResponse(serverResponse) {
    newsWrapperEl.innerHTML = "";

    if (!serverResponse || !serverResponse.length) {
      console.log("No news")
      newsWrapperEl.innerHTML =
        `<div class="news-slider__item swiper-slide">
          <a href="#" class="news__item">
            <div class="news-date">
              <span class="news-date__txt">GoodGames новини</span>
            </div>
            <div class="news__title">
              Немає новин
            </div>

            <p class="news__txt">
              Новини ще не сформувалися, зайдіть сюди пізніше 😉
            </p>
          </a>
        </div>`;
      return;
    }

    for (let oneNewsInfo of serverResponse) {
      parseOneNews(oneNewsInfo);
    }

    const scriptEl = document.createElement("script");
    scriptEl.src = "script.js";
    document.body.appendChild(scriptEl)
  }

  function parseOneNews(oneNewsInfo) {
    const months = ["січня", "лютого", "березня", "квітня", "травня", "червня", "липня", "серпня", "вересня", "жовтня", "листопада", "грудня"]
    const date = new Date(oneNewsInfo.date);
    const day = date.getDate();
    const month = months[date.getMonth()];


    newsWrapperEl.innerHTML +=
      `<div class="news-slider__item swiper-slide">
        <a onclick="news_show();" style="cursor: pointer;" class="news__item">
          <div class="news-date">
            <span class="news-date__title">${day}</span>
            <span class="news-date__txt">${month}</span>
          </div>
          <div class="news__title">
            ${oneNewsInfo.header}
          </div>

          <p class="news__txt">
            ${oneNewsInfo.body}
          </p>

          <div class="news__img">
            <img src="https://res.cloudinary.com/muhammederdem/image/upload/q_60/v1537132205/news-slider/item-2.webp" alt="news">
          </div>
        </a>
      </div>`;
  }
}