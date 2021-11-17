var bg = document.querySelector('.item-bg');
var items = document.querySelectorAll('.news__item');
var item = document.querySelector('.news__item');
const newsWrapperEl = document.querySelector(".news-slider__wrp");

function cLog(content) {
  console.log(content)
}

if($(window).width() > 800) {
  $(document).on("mouseover", ".news__item", function (_event, _element) {

    var newsItem = document.querySelectorAll('.news__item');
    newsItem.forEach(function (element, index) {
      element.addEventListener('mouseover', function () {
        var x = this.getBoundingClientRect().left;
        var y = this.getBoundingClientRect().top;
        var width = this.getBoundingClientRect().width;
        var height = this.getBoundingClientRect().height;

        $('.item-bg').addClass('active');
        $('.news__item').removeClass('active');
        // $('.news__item').removeClass('active');


        bg.style.width = width + 'px';
        bg.style.height = height + 'px';
        bg.style.transform = 'translateX(' + x + 'px ) translateY(' + y + 'px)';
      });

      element.addEventListener('mouseleave', function () {
        $('.item-bg').removeClass('active');
        $('.news__item').removeClass('active');
      });

    });

  });
}


var swiper = new Swiper('.news-slider', {
  effect: 'coverflow',
  grabCursor: true,
  loop: true,
  centeredSlides: true,
  keyboard: true,
  spaceBetween: 0,
  slidesPerView: 'auto',
  speed: 300,
  coverflowEffect: {
    rotate: 0,
    stretch: 0,
    depth: 0,
    modifier: 3,
    slideShadows: false
  },
  breakpoints: {
    480: {
      spaceBetween: 0,
      centeredSlides: true
    }
  },
  simulateTouch: true,
  navigation: {
    nextEl: '.news-slider-next',
    prevEl: '.news-slider-prev'
  },
  pagination: {
    el: '.news-slider__pagination',
    clickable: true
  },
  on: {
    init: function () {
      var activeItem = document.querySelector('.swiper-slide-active');

      var sliderItem = activeItem.querySelector('.news__item');

      $('.swiper-slide-active .news__item').addClass('active');

      var x = sliderItem.getBoundingClientRect().left;
      var y = sliderItem.getBoundingClientRect().top;
      var width = sliderItem.getBoundingClientRect().width;
      var height = sliderItem.getBoundingClientRect().height;


      $('.item-bg').addClass('active');

      bg.style.width = width + 'px';
      bg.style.height = height + 'px';
      bg.style.transform = 'translateX(' + x + 'px ) translateY(' + y + 'px)';
    }
  }
});

swiper.on('touchEnd', function () {
  $('.news__item').removeClass('active');
  $('.swiper-slide-active .news__item').addClass('active');
});

swiper.on('slideChange', function () {
  $('.news__item').removeClass('active');
});

swiper.on('slideChangeTransitionEnd', function () {
  $('.news__item').removeClass('active');
  var activeItem = document.querySelector('.swiper-slide-active');

  var sliderItem = activeItem.querySelector('.news__item');

  $('.swiper-slide-active .news__item').addClass('active');

  var x = sliderItem.getBoundingClientRect().left;
  var y = sliderItem.getBoundingClientRect().top;
  var width = sliderItem.getBoundingClientRect().width;
  var height = sliderItem.getBoundingClientRect().height;


  $('.item-bg').addClass('active');

  bg.style.width = width + 'px';
  bg.style.height = height + 'px';
  bg.style.transform = 'translateX(' + x + 'px ) translateY(' + y + 'px)';
});


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