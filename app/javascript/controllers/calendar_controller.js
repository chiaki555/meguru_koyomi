import { Controller } from "@hotwired/stimulus"
import { Calendar } from "@fullcalendar/core"
import dayGridPlugin from "@fullcalendar/daygrid"
import * as bootstrap from "bootstrap"

// import "@fullcalendar/core/index.css"
// import "@fullcalendar/daygrid/index.css"

export default class extends Controller {
  connect() {
    console.log("Stimulus: calendar controller connected!")

    // 既存カレンダーがあれば破棄
    if (this.calendar) {
      this.calendar.destroy()
      this.calendar = null
    }

    // DOM をクリア
    this.element.innerHTML = ""

    // FullCalendar インスタンス作成
    this.calendar = new Calendar(this.element, {
      plugins: [dayGridPlugin],
      initialView: "dayGridMonth",
      timeZone: "local",
      events: this.fetchEvents.bind(this),
      datesSet: () => this.updateMonthlyBaths(),
      eventClick: (info) => this.openModalFromEvent(info.event) // ← ここで呼ぶだけ
    })

    this.calendar.render()
  }

  // モーダルを開く処理メソッド
  openModalFromEvent(event) {
    const modal = document.getElementById(event.extendedProps.modalId)
    if (!modal) return

    modal.querySelector(".js-modal-title").textContent = event.title
    modal.querySelector(".js-modal-description").textContent =
      event.extendedProps.description

    const thumbnail = modal.querySelector(".js-modal-thumbnail")
    if (event.extendedProps.thumbnailUrl) {
      thumbnail.src = event.extendedProps.thumbnailUrl
      thumbnail.classList.remove("d-none")
    } else {
      thumbnail.classList.add("d-none")
    }

    bootstrap.Modal.getOrCreateInstance(modal).show()
  }

  // サイドバー：今月の季節湯
  updateMonthlyBaths() {
  const list = document.querySelector(".js-monthly-baths")
  if (!list) return

  list.innerHTML = ""

  // カレンダーが表示している月を取得
  const viewDate = this.calendar.getDate()
  const year = viewDate.getFullYear()
  const month = viewDate.getMonth()

  const baths = this.calendar.getEvents().filter(event => {
    if (event.extendedProps.type !== "bath") return false

    const date = event.start
    return date.getFullYear() === year && date.getMonth() === month
  })

baths.forEach(event => {
  const li = document.createElement("li")

  const a = document.createElement("a")
  a.href = "#"
  a.textContent = event.title
  a.classList.add("small")

  // サイドバーのリンクからもモーダルを開く
  a.addEventListener("click", e => {
  e.preventDefault()
  this.openModalFromEvent(event)
  })

  li.appendChild(a)
  list.appendChild(li)
  })
}

async fetchEvents(info, successCallback, failureCallback) {
  try {
    const res = await fetch("/homes.json")
    const data = await res.json()
    successCallback(data)

  } catch (e) {
    failureCallback(e)
  }
}

  // 外部からイベント一覧を取得するメソッド
  getEvents() {
    if (!this.calendar) return []
    return this.calendar.getEvents()
  }

  // 外部から日付を変更するメソッド
  goToDate(dateStr) {
    if (!this.calendar) return
    this.calendar.gotoDate(dateStr)
  }
}
