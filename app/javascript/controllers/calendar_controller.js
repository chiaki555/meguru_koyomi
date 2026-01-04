import { Controller } from "@hotwired/stimulus"
import { Calendar } from "@fullcalendar/core"
import dayGridPlugin from "@fullcalendar/daygrid"
import * as bootstrap from "bootstrap"

// import "@fullcalendar/core/index.css"
// import "@fullcalendar/daygrid/index.css"

export default class extends Controller {
  connect() {
    console.log("🔥 calendar_controller.js LOADED 🔥")
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
      datesSet: () => this.updateSidebar(),
      eventClick: (info) => this.openModalFromEvent(info.event),
      eventContent: (arg) => {
        const iconUrl = arg.event.extendedProps.icon_url
        const title = arg.event.title

        if (!iconUrl) return { html: `<span>${title}</span>` }

        return {
          html: `
            <span class="d-inline-flex align-items-center gap-1">
              <img src="${iconUrl}" width="16" height="16" />
              <span>${title}</span>
            </span>
          `
        }
      }
    })

    this.calendar.render()
  }

  // サイドバー更新
  updateSidebar() {
    this.updateMonthlyBaths()
    this.updateTodayOrNextEvent()
  }

  // 今月の季節湯リスト
  updateMonthlyBaths() {
    const list = document.querySelector(".js-monthly-baths")
    if (!list) return
    list.innerHTML = ""

    const viewDate = this.calendar.getDate()
    const year = viewDate.getFullYear()
    const month = viewDate.getMonth()

    const baths = this.calendar.getEvents().filter(event => {
      return event.extendedProps.type === "bath" &&
             event.start.getFullYear() === year &&
             event.start.getMonth() === month
    })

    baths.forEach(event => {
      const li = document.createElement("li")
      const a = document.createElement("a")
      a.href = "#"

      // アイコン表示
      if (event.extendedProps.icon_url) {
        const img = document.createElement("img")
        img.src = event.extendedProps.icon_url
        img.classList.add("me-1")
        img.style.width = "16px"
        img.style.height = "16px"
        img.style.verticalAlign = "middle"
        a.appendChild(img)
      }

      const span = document.createElement("span")
      span.textContent = event.title
      a.appendChild(span)
      a.classList.add("small")

      a.addEventListener("click", e => {
        e.preventDefault()
        this.openModalFromEvent(event)
      })

      li.appendChild(a)
      list.appendChild(li)
    })
  }

  // 今日 or 次の行事
  updateTodayOrNextEvent() {
    const label = document.querySelector(".js-event-label")
    const list = document.querySelector(".js-event-title")
    if (!label || !list) return
    list.innerHTML = ""

    const today = new Date()
    today.setHours(0, 0, 0, 0)

    const events = this.calendar.getEvents()
      .filter(e => e.extendedProps.type === "event")
      .sort((a, b) => a.start - b.start)

    const todayEvents = events.filter(e => {
      const d = new Date(e.start)
      d.setHours(0, 0, 0, 0)
      return d.getTime() === today.getTime()
    })

    const uniqByTemplate = events => {
      const map = new Map()
      events.forEach(e => {
        const key = e.extendedProps.event_template_id
        if (!map.has(key)) map.set(key, e)
      })
      return Array.from(map.values())
    }

    let targetEvents = []
    if (todayEvents.length > 0) {
      label.textContent = "今日の行事"
      targetEvents = todayEvents
    } else {
      const nextEvent = events.find(e => e.start > today)
      if (!nextEvent) return
      const nextDate = new Date(nextEvent.start)
      nextDate.setHours(0, 0, 0, 0)
      label.textContent = "次の行事"
      targetEvents = events.filter(e => {
        const d = new Date(e.start)
        d.setHours(0, 0, 0, 0)
        return d.getTime() === nextDate.getTime()
      })
    }

    targetEvents = uniqByTemplate(targetEvents)

    targetEvents.forEach(event => {
      const li = document.createElement("li")
      const a = document.createElement("a")
      a.href = "#"

      if (event.extendedProps.icon_url) {
        const img = document.createElement("img")
        img.src = event.extendedProps.icon_url
        img.classList.add("me-1")
        img.style.width = "16px"
        img.style.height = "16px"
        img.style.verticalAlign = "middle"
        a.appendChild(img)
      }

      const span = document.createElement("span")
      span.textContent = event.title
      a.appendChild(span)

      a.addEventListener("click", e => {
        e.preventDefault()
        this.openModalFromEvent(event)
      })

      li.appendChild(a)
      list.appendChild(li)
    })
  }

  // データ取得
  async fetchEvents(info, successCallback, failureCallback) {
    try {
      const res = await fetch("/homes.json")
      const data = await res.json()
      console.log("fetchEvents start")
      successCallback(data)

      // イベント取得後にサイドバー更新
      this.updateSidebar()
    } catch (e) {
      failureCallback(e)
    }
  }

  // モーダルを開く
  openModalFromEvent(event) {
 
    const modal = document.getElementById(event.extendedProps.modalId)
    if (!modal) return

    const body = modal.querySelector(".js-event-body")
    if (body) body.classList.remove("d-none")

    // タイトル
    const titleEl = modal.querySelector(".js-modal-title")
    if (titleEl) titleEl.textContent = event.title

    // 概要
    const desc = modal.querySelector(".js-modal-description")
    if (desc) desc.textContent = event.extendedProps.description || ""

    // 行事
    if (event.extendedProps.type === "event") {
      const thumb = modal.querySelector(".js-event-thumbnail")
      if (thumb) {
        thumb.src = event.extendedProps.thumbnail_url || "https://placehold.jp/80x80.png"
        thumb.classList.add("modal-event-thumbnail")
        thumb.classList.remove("d-none")
      }

      // 行事食
      const foodsEl = modal.querySelector(".js-modal-foods")
      if (foodsEl) {
        foodsEl.innerHTML = "";

        const foods = event.extendedProps.foods || []
        
        if (foods.length === 0) {
          const p = document.createElement("p")
          p.className = "text-muted"
          p.textContent = "該当なし"
          foodsEl.appendChild(p)
        } else {

        foods.forEach(food => {
          const li = document.createElement("li")
          li.className = "row align-items-center"

          // 左：画像
          const colImg = document.createElement("div")
          colImg.className = "col-6"

          const img = document.createElement("img")
          img.src = food.thumbnail_url || "https://placehold.jp/80x80.png"
          img.classList.add("modal-food-thumbnail")

          colImg.appendChild(img)

          // 右：名前
          const colText = document.createElement("div")
          colText.className = "col-6"

          const text = document.createElement("span")
          text.textContent = food.name

          colText.appendChild(text)

          li.appendChild(colImg)
          li.appendChild(colText)

          foodsEl.appendChild(li)
        })
      }
    }

      // おすすめスポット
      const spotsEl = modal.querySelector(".js-modal-spots")
      if (spotsEl) {
        spotsEl.innerHTML = "";

        const spots = event.extendedProps.spots || []
        
        if (spots.length === 0) {
          const li = document.createElement("li")
          li.className = "text-muted"
          li.textContent = "該当なし"
          spotsEl.appendChild(li)
        } else {

        spots.forEach(spot => {
          const li = document.createElement("li")
          li.className = "row align-items-center"

          // 左: 画像
          const colImg = document.createElement("div")
          colImg.className = "col-6"

          const img = document.createElement("img")
          img.src = spot.image_url || "https://placehold.jp/80x80.png"
          img.classList.add("modal-spot-thumbnail")

          colImg.appendChild(img)

          // 右: 名前
          const colText = document.createElement("div")
          colText.className = "col-6"

          const text = document.createElement("span")
          text.textContent = spot.name

          colText.appendChild(text)

          li.appendChild(colImg)
          li.appendChild(colText)

          spotsEl.appendChild(li)
        })
      }
    }
  }

    // 季節湯
    if (event.extendedProps.type === "bath") {
      const thumb = modal.querySelector(".js-modal-thumbnail")
      if (thumb) {
        thumb.src = event.extendedProps.thumbnail_url || "https://placehold.jp/80x80.png"
        thumb.classList.add("modal-bath-thumbnail")
        thumb.classList.remove("d-none")
      }
    }

    bootstrap.Modal.getOrCreateInstance(modal).show()
  }

  // 外部からイベント一覧取得
  getEvents() {
    if (!this.calendar) return []
    return this.calendar.getEvents()
  }

  // 外部から日付移動
  goToDate(dateStr) {
    if (!this.calendar) return
    this.calendar.gotoDate(dateStr)
  }
}
