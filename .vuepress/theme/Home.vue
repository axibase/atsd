<template>
  <div class="home-wrapper">
    <div class="home">
      <div class="hero-bg"></div>
      <div class="hero-bg-mask"></div>
      <div class="hero">
        <img v-if="data.heroImage" :src="$withBase(data.heroImage)" alt="hero">
        <h1>{{ data.heroText || $title || 'Hello' }}</h1>
        <p class="description">
          {{ data.tagline || '' }}
        </p>
        <p class="action" v-if="data.actionText && data.actionLink">
          <NavLink class="action-button" :item="actionLink"/>
        </p>
      </div>
      <div class="features" v-if="data.features && data.features.length">
        <div class="feature" v-for="feature in data.features">
          <h2>{{ feature.title }}</h2>
          <p><span v-html="feature.details"></span></p>
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
    background: linear-gradient(105deg, #111 0%, rgba(0,0,0,0.6) 35%, rgba(0,0,0,0) 70% 100%)
    // Blue
    // background linear-gradient(105deg, #19325b 0%, rgba(23, 43, 76, 0.94) 35%, rgba(0,0,0,0) 70% 100%)
    position: absolute;
    left: 0;
    top: 50px;
    z-index: -1;
    width: 100vw;
    height: 500px;

  .hero-bg
    // Blue
    // background: #19325b url(../public/images/main_logo.png);
    background: #111 url(../public/images/main_logo.png);
    background-position-x -60%
    background-size auto 100%
    width: 100vw;
    height: 500px;
    position: absolute;
    left: 0;
    top: 50px;
    z-index: -1;
  .hero
    height 300px
    padding 80px 0
    color whitesmoke;
    margin-left: -80px;
    img
      max-height 280px
      display block
      margin 3rem auto 1.5rem
    h1
      font-size 3rem
      text-shadow 1px 1px 2px #555
      margin-top: 15px;
      width 60%;
    .description
      max-width 35rem
      font-size 1.6rem
      line-height 1.3
      color darken(whitesmoke, 10%)
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

  .feature-highlight
    min-height: 240px;
    position: relative;
    padding: 40px;

    &:nth-child(odd)
      margin-left: 30%;
      left 48px
      // Inverted color
      // color whitesmoke

      // Inversion
      // a
      //   color #f08d49

      .feature-images
        left: -490px
      
      &:before
        background: #f5f5f5
        box-shadow: 0 14px 6px -12px rgba(0,0,0,0.2) inset
      // Inversion 
      // background: #233453
      // background: linear-gradient(-30deg, lighten(#233453, 20%),darken(#233453, 20%))
      // background: #19325b
      // background: linear-gradient(-30deg, lighten(#19325b, 20%),darken(#19325b, 20%))

        
    &:nth-child(even)
      margin-right: 30%
      right 48px

      .feature-images
        right: -490px;
      
      &:before
        background: #fefefe;
        box-shadow: 0 14px 6px -12px rgba(0,0,0,0.3) inset

    &:before
      content: ''
      position: absolute;
      left: -100vw;
      width: 200vw;
      display: block;
      height: 100%;
      top: 0;
      z-index: -1;

    .feature-images
      position: absolute;
      top: 48px;
      width: 480px;


    img
      width: 480px;
      border-radius 4px
      box-shadow  0 0 8px rgba(0, 0, 0, 0.2),
                  0 0 2px rgba(0, 0, 0, 0.2),
                  2px 2px 4px rgba(0, 0, 0, 0.2)

  .features
    padding 1.2rem 0
    margin-bottom: 15px;
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

@media (max-width: 1024px)
  .home
    .hero
      margin-left 0
      
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
    .hero-bg, .hero-bg-mask
      height 300px
    .hero-bg-mask
      background: linear-gradient(125deg, #000 0% 15%, rgba(0,0,0,0.6) 55%, rgba(0,0,0,0) 70% 100%)
      background-position: -300px -180px;
      background-repeat: no-repeat;
      background-size: 200% 200%;
    .hero
      height 200px
      padding 20px 0
      img
        max-height 210px
        margin 2rem auto 1.2rem
      h1
        font-size 1.4rem
      h1, .action
        margin 1.2rem auto
      .description
        font-size 1.2rem
        width: 60%;
        margin: 32px 0 40px 0;
      .action-button
        font-size 1rem
        padding 0.6rem 1.2rem
    .features
      margin-bottom 1.2rem
    .feature
      padding 0 0.2rem
      h2
        font-size 1.25rem
    .feature-highlight
      padding 1rem 0.2rem 2rem 0.2rem
      &:nth-child(even), &:nth-child(odd)
        margin: 0
        left 0
        right 0

      .feature-images
        position static
        width 100%

      img
        width 100%

      li
        margin 0.2rem 0
</style>
