<template>
  <div class="chat-overlay-wrap">
    <transition name="overlay-slide">
      <div v-if="side" class="overlay-panel">
        <div class="overlay-header">
          <span class="overlay-label">Chat</span>
          <div class="overlay-header-actions">
            <i class="fas fa-up-right-from-square" @click="switchToFloat" title="Float chat" />
            <i class="fas fa-table-columns" @click="switchToDocked" title="Dock chat" />
          </div>
        </div>
        <ul class="overlay-messages" ref="messages" @click="onClick">
          <template v-for="(message, index) in history">
            <li v-if="message.type === 'text'" :key="index" class="bubble">
              <div class="bubble-meta">
                <span class="bubble-author">{{ member(message.id).displayname }}</span>
                <span class="bubble-time">{{ timestamp(message.created) }}</span>
              </div>
              <neko-markdown class="bubble-body" :source="message.content" />
            </li>
            <li v-if="message.type === 'event'" :key="'e' + index" class="bubble-event">
              <strong>{{ member(message.id).displayname }}</strong>
              {{ message.content }}
            </li>
          </template>
        </ul>
        <div v-if="!muted" class="overlay-send">
          <textarea ref="input" :placeholder="$t('send_a_message')" v-model="content" @keydown="onKeyDown" />
          <span class="gif-menu" @click.stop.prevent="onGif">GIF</span>
          <i class="fas fa-paper-plane send-icon" @click="send" />
        </div>
      </div>
    </transition>
    <div v-if="gif" class="overlay-gif-wrap">
      <neko-gif @picked="onGifPicked" @done="gif = false" />
    </div>
    <div class="overlay-tab" @click="toggleSide" :title="side ? 'Hide chat' : 'Show chat'">
      <i :class="side ? 'fas fa-chevron-right' : 'fas fa-comment-alt'" />
    </div>
  </div>
</template>

<style lang="scss">
  .chat-overlay-wrap {
    position: fixed;
    right: 0;
    bottom: 140px;
    display: flex;
    flex-direction: row;
    align-items: flex-end;
    z-index: 800;
    pointer-events: none;

    > * {
      pointer-events: auto;
    }

    @media only screen and (max-width: 768px) {
      bottom: 10px;
    }

    .overlay-panel {
      width: 300px;
      max-height: 480px;
      display: flex;
      flex-direction: column;
      // Panel itself is transparent — header and send bar have their own backgrounds
      background: transparent;
      border-radius: 10px 0 0 10px;
      overflow: hidden;

      .overlay-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 7px 10px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.06);
        flex-shrink: 0;
        background: rgba($background-floating, 0.88);
        backdrop-filter: blur(10px);
        -webkit-backdrop-filter: blur(10px);
        box-shadow: 0 1px 6px rgba(0, 0, 0, 0.3);

        .overlay-label {
          font-size: 11px;
          font-weight: 700;
          color: $text-muted;
          text-transform: uppercase;
          letter-spacing: 0.8px;
        }

        .overlay-header-actions {
          display: flex;
          gap: 10px;

          i {
            font-size: 11px;
            color: $text-muted;
            cursor: pointer;

            &:hover {
              color: $text-normal;
            }
          }
        }
      }

      .overlay-messages {
        flex: 1;
        overflow-y: auto;
        overflow-x: hidden;
        padding: 5px 6px;
        max-height: 380px;
        scrollbar-width: thin;
        scrollbar-color: rgba(255, 255, 255, 0.08) transparent;

        // Individual bubbles: flex column, left-aligned
        display: flex;
        flex-direction: column;
        align-items: flex-start;
        gap: 4px;

        &::-webkit-scrollbar {
          width: 3px;
        }

        &::-webkit-scrollbar-thumb {
          background: rgba(255, 255, 255, 0.1);
          border-radius: 2px;
        }

        li.bubble {
          // Individual pill bubble
          background: rgba($background-floating, 0.84);
          border-radius: 10px;
          padding: 5px 10px 6px;
          max-width: calc(100% - 4px);
          word-break: break-word;
          overflow-wrap: break-word;
          align-self: flex-start;

          &:hover {
            background: rgba($background-floating, 0.96);
          }

          .bubble-meta {
            display: flex;
            align-items: baseline;
            gap: 5px;
            margin-bottom: 2px;
          }

          .bubble-author {
            font-size: 11px;
            font-weight: 700;
            color: $style-primary;
            white-space: nowrap;
          }

          .bubble-time {
            font-size: 9px;
            color: $text-muted;
            white-space: nowrap;
          }

          ::v-deep .bubble-body {
            font-size: 13px;
            color: $text-normal;
            line-height: 1.45;
            word-break: break-word;
            overflow-wrap: break-word;

            img.chat-image {
              display: block;
              max-width: 100%;
              max-height: 200px;
              border-radius: 6px;
              margin-top: 4px;
            }

            a {
              color: $text-link;
            }

            strong {
              font-weight: 700;
            }

            em {
              font-style: italic;
            }

            code {
              background: rgba(255, 255, 255, 0.1);
              border-radius: 3px;
              padding: 0 3px;
              font-size: 0.85em;
            }

            span.spoiler {
              background: rgba(255, 255, 255, 0.1);
              padding: 0 2px;
              border-radius: 3px;
              cursor: pointer;

              span {
                opacity: 0;
              }

              &.active {
                background: rgba(255, 255, 255, 0.05);
                cursor: default;

                span {
                  opacity: 1;
                }
              }
            }
          }
        }

        li.bubble-event {
          align-self: flex-start;
          padding: 2px 8px;
          font-size: 10px;
          color: rgba($text-muted, 0.7);
          background: rgba($background-floating, 0.5);
          border-radius: 8px;

          strong {
            color: $text-muted;
            font-weight: 600;
          }
        }
      }

      .overlay-send {
        flex-shrink: 0;
        display: flex;
        align-items: center;
        gap: 6px;
        padding: 6px 8px;
        border-top: 1px solid rgba(255, 255, 255, 0.06);
        background: rgba($background-floating, 0.88);
        backdrop-filter: blur(10px);
        -webkit-backdrop-filter: blur(10px);

        textarea {
          flex: 1;
          background: rgba(255, 255, 255, 0.07);
          border: none;
          border-radius: 6px;
          padding: 6px 8px;
          color: $text-normal;
          font-family: $text-family;
          font-size: 13px;
          resize: none;
          height: 32px;
          caret-color: $text-normal;
          scrollbar-width: none;

          &::-webkit-scrollbar {
            display: none;
          }

          &::placeholder {
            color: $text-muted;
          }

          &:focus {
            outline: none;
            background: rgba(255, 255, 255, 0.1);
          }
        }

        .gif-menu {
          font-size: 10px;
          font-weight: 700;
          color: $text-muted;
          cursor: pointer;
          padding: 0 3px;
          border-radius: 3px;
          letter-spacing: 0.3px;
          flex-shrink: 0;
          line-height: 20px;

          &:hover {
            color: $text-normal;
            background: rgba(255, 255, 255, 0.08);
          }
        }

        .send-icon {
          color: $text-muted;
          cursor: pointer;
          font-size: 13px;
          flex-shrink: 0;

          &:hover {
            color: $style-primary;
          }
        }
      }
    }

    .overlay-gif-wrap {
      position: absolute;
      bottom: 44px;
      right: 22px;
      z-index: 5;
    }

    .overlay-tab {
      width: 22px;
      height: 48px;
      background: rgba($background-floating, 0.88);
      backdrop-filter: blur(10px);
      -webkit-backdrop-filter: blur(10px);
      border-radius: 6px 0 0 6px;
      display: flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      flex-shrink: 0;

      i {
        font-size: 10px;
        color: $text-muted;
      }

      &:hover {
        background: rgba($background-primary, 0.92);

        i {
          color: $text-normal;
        }
      }
    }
  }

  .overlay-slide-enter-active,
  .overlay-slide-leave-active {
    transition: transform 0.18s ease, opacity 0.18s ease;
  }

  .overlay-slide-enter,
  .overlay-slide-leave-to {
    transform: translateX(16px);
    opacity: 0;
  }
</style>

<script lang="ts">
  import { Component, Ref, Watch, Vue } from 'vue-property-decorator'
  import { formatRelative } from 'date-fns'

  import Markdown from './markdown'
  import GifPicker from './gif-picker.vue'

  @Component({
    name: 'neko-chat-overlay',
    components: {
      'neko-markdown': Markdown,
      'neko-gif': GifPicker,
    },
  })
  export default class extends Vue {
    @Ref('messages') readonly _messages!: HTMLElement
    @Ref('input') readonly _input!: HTMLTextAreaElement

    content = ''
    gif = false

    get side() {
      return this.$accessor.client.side
    }

    get history() {
      return this.$accessor.chat.history
    }

    get muted() {
      return this.$accessor.user.muted
    }

    @Watch('history')
    onHistoryChange() {
      this.$nextTick(() => {
        if (this._messages) {
          this._messages.scrollTop = this._messages.scrollHeight
        }
      })
    }

    mounted() {
      this.$nextTick(() => {
        if (this._messages) {
          this._messages.scrollTop = this._messages.scrollHeight
        }
      })
    }

    member(id: string) {
      return this.$accessor.user.members[id] || { id, displayname: this.$t('somebody') }
    }

    timestamp(time: Date) {
      const str = formatRelative(time, new Date())
      return `${str.charAt(0).toUpperCase()}${str.slice(1)}`
    }

    toggleSide() {
      this.$accessor.client.toggleSide()
    }

    switchToFloat() {
      this.$accessor.client.toggleFloating()
    }

    switchToDocked() {
      this.$accessor.client.setOverlay(false)
      this.$accessor.client.setSide(true)
    }

    onGif() {
      this.gif = !this.gif
    }

    onGifPicked(url: string) {
      if (!url) return
      this.$accessor.chat.sendMessage(url)
      this.gif = false
    }

    send() {
      if (!this.content.trim()) return
      this.$accessor.chat.sendMessage(this.content)
      this.content = ''
    }

    onKeyDown(event: KeyboardEvent) {
      if (this.muted) return
      if (event.keyCode !== 13 || event.shiftKey) return
      if (!this.content) {
        event.preventDefault()
        return
      }
      this.send()
      event.preventDefault()
    }

    onClick(event: { target?: HTMLElement; preventDefault(): void }) {
      const { target } = event
      if (!target) return
      if (target.tagName.toLowerCase() === 'span' && target.classList.contains('spoiler')) {
        target.classList.add('active')
        event.preventDefault()
      }
      if (
        target.parentElement?.tagName.toLowerCase() === 'span' &&
        target.parentElement.classList.contains('spoiler')
      ) {
        target.parentElement.classList.add('active')
        event.preventDefault()
      }
    }
  }
</script>
