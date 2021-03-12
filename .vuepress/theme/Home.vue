<template>
  <div class="home-wrapper">
    <div class="home">
      <div class="hero-bg"></div>
      <!-- <div class="hero-bg-mask"></div> -->
      <div class="hero">
        <img v-if="data.heroImage" :src="$withBase(data.heroImage)" alt="hero">
        <h1>{{ data.heroText || $title || 'Hello' }}</h1>
        <p class="description">
          {{ data.tagline || $description || 'Welcome to your VuePress site' }}
        </p>
        <p class="action" v-if="data.actionText && data.actionLink">
          <NavLink class="action-button" :item="actionLink"/>
        </p>
      </div>
      <div class="features" v-if="data.features && data.features.length">
        <div class="feature" v-for="feature in data.features">
          <h2>{{ feature.title }}</h2>
          <p>{{ feature.details }}</p>
        </div>
      </div>
      <Content custom/>
      <div class="footer" v-if="data.footer">
        {{ data.footer }}
      </div>
    </div>
  </div>
</template>

<script>
import NavLink from './NavLink.vue'

export default {
  components: { NavLink },
  computed: {
    data () {
      return this.$page.frontmatter
    },
    actionLink () {
      return {
        link: this.data.actionLink,
        text: this.data.actionText
      }
    }
  }
}
</script>

<style lang="stylus">
@import './styles/config.styl'

.home-wrapper
  width 100%
  overflow-x hidden;

.home
  padding $navbarHeight 2rem 0
  max-width 960px
  margin 0px auto
  .hero-bg-mask
    background: linear-gradient(to right, #2b2e2c 0%, #2b2e2c 60%, transparent 70%, transparent 100%); 
    position: absolute;
    left: 0;
    top: 50px;
    z-index: -1;
    width: 100vw;
    height: 500px;
  .hero-bg
    background: url(../public/images/main_logo.png);
    width: 100vw;
    height: 500px;
    position: absolute;
    left: 0;
    top: 50px;
    z-index: -1;
    background-size: contain;
    background-position-x 50%
  .hero
    height 300px
    padding 80px 0
    color whitesmoke;
    img
      max-height 280px
      display block
      margin 3rem auto 1.5rem
    h1
      font-size 3rem
    .description
      max-width 35rem
      font-size 1.6rem
      line-height 1.3
      color darken(whitesmoke, 20%)
    .action-button
      display inline-block
      font-size 1.2rem
      color #fff
      background-color $accentColor
      padding 0.8rem 1.6rem
      border-radius 4px
      transition background-color .1s ease
      box-sizing border-box
      border-bottom 1px solid darken($accentColor, 10%)
      &:hover
        background-color lighten($accentColor, 10%)
  .features
    padding 1.2rem 0
    margin-bottom: 120px;
    margin-top 2.5rem
    display flex
    flex-wrap wrap
    align-items flex-start
    align-content strech
    justify-content space-between
  .feature
    flex-grow 1
    flex-basis 30%
    max-width 30%
    h2
      font-size 1.4rem
      font-weight 500
      border-bottom none
      padding-bottom 0
      color lighten($textColor, 10%)
    p
      color lighten($textColor, 25%)
  .footer
    padding 2.5rem
    border-top 1px solid $borderColor
    text-align center
    color lighten($textColor, 25%)

@supports(background-blend-mode: multiply)
  .home
    .hero-bg
      background-blend-mode multiply
      background: linear-gradient(105deg, #222 0% 15%, #444 35%, rgba(255,255,255,0) 70% 100%),
                  url(../public/images/main_logo.png);
      background-position-x 0, -60%
      background-size auto 100%

@media (max-width: $MQMobile)
  .home
    .features
      flex-direction column
    .feature
      max-width 100%
      padding 0 2.5rem

@media (max-width: $MQMobileNarrow)
  .home
    padding-left 1.5rem
    padding-right 1.5rem
    .hero
      img
        max-height 210px
        margin 2rem auto 1.2rem
      h1
        font-size 2rem
      h1, .description, .action
        margin 1.2rem auto
      .description
        font-size 1.2rem
      .action-button
        font-size 1rem
        padding 0.6rem 1.2rem
    .feature
      h2
        font-size 1.25rem
</style>
