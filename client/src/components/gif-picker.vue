<template>
  <div class="neko-gif" v-on-clickaway="onClickAway">
    <div class="gif-search">
      <i class="fas fa-search" />
      <input
        type="text"
        ref="search"
        v-model="search"
        placeholder="Search GIPHY..."
        @input="onSearchInput"
        autocomplete="off"
      />
    </div>
    <div class="gif-grid-wrap">
      <div v-if="loading" class="gif-state">
        <i class="fas fa-spinner fa-spin" />
      </div>
      <div v-else-if="error" class="gif-state">
        <i class="fas fa-exclamation-circle" />
        <span>{{ error }}</span>
      </div>
      <div v-else-if="gifs.length === 0" class="gif-state">
        <span>No GIFs found</span>
      </div>
      <div v-else class="gif-grid">
        <img
          v-for="gif in gifs"
          :key="gif.id"
          :src="gif.preview"
          :alt="gif.title"
          class="gif-item"
          @click="onPick(gif)"
          loading="lazy"
        />
      </div>
    </div>
    <div class="gif-footer">
      <span>Powered by</span>
      <strong>GIPHY</strong>
    </div>
  </div>
</template>

<style lang="scss">
  .neko-gif {
    width: 300px;
    height: 350px;
    background: $background-secondary;
    display: flex;
    flex-direction: column;
    border-radius: 5px;
    overflow: hidden;
    box-shadow: $elevation-high;

    .gif-search {
      flex-shrink: 0;
      display: flex;
      align-items: center;
      gap: 8px;
      padding: 10px;
      border-bottom: 1px solid $background-tertiary;

      i {
        color: $text-muted;
        font-size: 13px;
        flex-shrink: 0;
      }

      input {
        flex: 1;
        border: none;
        background: $background-floating;
        color: $interactive-normal;
        padding: 5px 8px;
        border-radius: 4px;
        font-size: 13px;

        &::placeholder {
          color: $text-muted;
        }

        &:focus {
          outline: none;
        }
      }
    }

    .gif-grid-wrap {
      flex: 1;
      overflow-y: auto;
      overflow-x: hidden;
      scrollbar-width: thin;
      scrollbar-color: $background-tertiary transparent;
      padding: 4px;

      &::-webkit-scrollbar {
        width: 4px;
      }

      &::-webkit-scrollbar-thumb {
        background-color: $background-tertiary;
        border-radius: 4px;
      }

      .gif-state {
        height: 200px;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        gap: 8px;
        color: $text-muted;
        font-size: 13px;

        i {
          font-size: 24px;
        }
      }

      .gif-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 4px;

        .gif-item {
          width: 100%;
          height: 90px;
          object-fit: cover;
          border-radius: 4px;
          cursor: pointer;
          transition: opacity 0.15s;
          display: block;

          &:hover {
            opacity: 0.8;
          }
        }
      }
    }

    .gif-footer {
      flex-shrink: 0;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 4px;
      height: 28px;
      background: $background-tertiary;
      font-size: 11px;
      color: $text-muted;

      strong {
        color: $text-normal;
        font-weight: 700;
        letter-spacing: 0.5px;
      }
    }
  }
</style>

<script lang="ts">
  import { Component, Ref, Vue } from 'vue-property-decorator'
  import { directive as onClickaway } from 'vue-clickaway'

  interface Gif {
    id: string
    title: string
    preview: string
    url: string
  }

  const GIPHY_DEFAULT_KEY = 'dc6zaTOxFJmzC'

  @Component({
    name: 'neko-gif',
    directives: { onClickaway },
  })
  export default class extends Vue {
    @Ref('search') readonly _search!: HTMLInputElement

    search = ''
    gifs: Gif[] = []
    loading = false
    error = ''
    private _searchTimer: number | null = null

    get apiKey(): string {
      return this.$accessor.settings.giphy_api_key || process.env.VUE_APP_GIPHY_API_KEY || GIPHY_DEFAULT_KEY
    }

    mounted() {
      this.fetchTrending()
      this.$nextTick(() => this._search && this._search.focus())
    }

    beforeDestroy() {
      if (this._searchTimer !== null) clearTimeout(this._searchTimer)
    }

    async fetchTrending() {
      this.loading = true
      this.error = ''
      try {
        const res = await fetch(`https://api.giphy.com/v1/gifs/trending?api_key=${this.apiKey}&limit=20&rating=pg`)
        if (!res.ok) throw new Error(`${res.status}`)
        const data = await res.json()
        this.gifs = this.parseGifs(data.data)
      } catch (e: any) {
        this.error = 'Could not load GIFs'
      } finally {
        this.loading = false
      }
    }

    async fetchSearch(query: string) {
      this.loading = true
      this.error = ''
      try {
        const res = await fetch(
          `https://api.giphy.com/v1/gifs/search?api_key=${this.apiKey}&q=${encodeURIComponent(
            query,
          )}&limit=20&rating=pg`,
        )
        if (!res.ok) throw new Error(`${res.status}`)
        const data = await res.json()
        this.gifs = this.parseGifs(data.data)
      } catch (e: any) {
        this.error = 'Could not load GIFs'
      } finally {
        this.loading = false
      }
    }

    parseGifs(data: any[]): Gif[] {
      return (data || []).map((item: any) => ({
        id: item.id,
        title: item.title || '',
        preview: (item.images?.fixed_height_small?.url || item.images?.fixed_height?.url || '') as string,
        url: (item.images?.fixed_height?.url || item.images?.original?.url || '') as string,
      }))
    }

    onSearchInput() {
      if (this._searchTimer !== null) clearTimeout(this._searchTimer)
      if (!this.search.trim()) {
        this.fetchTrending()
        return
      }
      this._searchTimer = window.setTimeout(() => {
        this.fetchSearch(this.search)
      }, 400)
    }

    onPick(gif: Gif) {
      this.$emit('picked', gif.url)
    }

    onClickAway() {
      this.$emit('done')
    }
  }
</script>
