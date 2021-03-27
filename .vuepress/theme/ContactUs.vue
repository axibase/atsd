<template>
  <section v-if="url" class="contact-us-block">
    <h2>{{ labels.title || "" }}</h2>
    <p class="send-status" v-if="sendStatus=='success'">
      {{ labels.successText || "" }}
    </p>
    <template v-else>
      <p class="send-status" v-if="sendStatus=='error'">
        {{ labels.errorText || "" }}
      </p>
      <form :action="url" :method="method" ref="form" v-on:submit.prevent="sendForm">
        <p>
          <input name="firstName" required type="text" v-model="form.firstName" :placeholder="labels.firstNameText + '*'">
          <input name="lastName" required type="text" v-model="form.lastName" :placeholder="labels.lastNameText + '*'">
        </p>
        <p>
          <input name="company" required type="text" v-model="form.company" :placeholder="labels.companyText + '*'">
        </p>
        <p>
          <input name="email" required type="email" v-model="form.email" :placeholder="labels.emailText + '*'">
        </p>
        <p v-if="hasText">
          <textarea required name="message" v-model="form.message" :placeholder="labels.messageText + '*'"></textarea>
        </p>
        <p>
          <button type="submit">{{ labels.submitText }}</button>
        </p>
      </form>
    </template>
  </section>
</template>

<script>
export default {
  data() {
    return {
      sendStatus: "",
      form: {
        firstName: "",
        lastName: "",
        company: "",
        email: "",
        message: this.options && this.options.content || "",
      }
    };
  },
  props: [ "options" ],
  computed: {
    url() {
      return (this.options && this.options.url)
        || (this.$site.themeConfig.feedback && this.$site.themeConfig.feedback.url);
    },
    method() {
      return (this.options && this.options.method)
        || (this.$site.themeConfig.feedback && this.$site.themeConfig.feedback.method)
        || "POST";
    },
    labels() {
      var defaults = {
        firstNameText: "First Name",
        lastNameText: "Last Name",
        emailText: "E-Mail",
        companyText: "Organization",
        messageText: "Message",
        submitText: "Submit",
        errorText: "Something went wrong, please, try again later",
        successText: "Submitted successfully",
        title: "Contact Us"
      };
      var options = (!this.options || typeof this.options !== "object") ? {} : this.options;
      var siteOptions = this.$site.themeConfig.feedback || {};
      return {...defaults, ...siteOptions, ...options};
    },
    hasText() {
      return !(this.options && this.options.content);
    }
  },
  methods: {
    sendForm() {
      /** @type {HTMLFormElement} */
      let form = this.$refs.form;
      if (!form && !form.checkValidity()) return;

      let params = Object.keys(this.form);
      let qs = params.map((name, i) => `${encodeURIComponent(name)}=${encodeURIComponent(this.form[name])}`).join('&');
      let url = this.url + '?' + qs;

      let xhr = new XMLHttpRequest();
      xhr.open(this.method, url, true);
      xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8")
      xhr.onload = () => {
        this.sendStatus = (xhr.status >= 400) ? "error" : "success";
      };
      xhr.onerror = xhr.onabort = xhr.ontimeout = () => {
        this.sendStatus = "error";
      };
      xhr.send(null);
    }
  }
}
</script>

<style lang="stylus">
@import './styles/config.styl'

.contact-us-block
  width 60%
  min-height 240px
  margin 0 auto

  h2
    margin 0.4rem 0.5rem

  p
    width 100%
    display flex

  .send-status
    margin 1.2rem 0.5rem
    font-size 1.2rem

  input, textarea, button
    border-radius 4px
    border 1px solid #ddd
    display block
    margin 0 0.5rem

    &:focus
      outline none 
      border-color $accentColor
      box-shadow 0 0 2px 1px $accentColor

  button
    padding 0.8rem 1.6rem 
    border-color $accentColor
    background-color $accentColor
    color #fff
    font-size 1.2rem
    background-color 0.1s ease
    font-weight 500
    cursor pointer
    border-bottom-color darken($accentColor, 10%)

    &:hover
      background-color lighten($accentColor, 10%)

  input, textarea
    padding 0.8rem
    width 100%
    font-size 1rem

  textarea
    font inherit 
    line-height 1.2
    min-height 8rem
    resize vertical
      
@media (max-width: $MQMobile)
  .contact-us-block
    width 80%

@media (max-width: $MQMobileNarrow)
  .contact-us-block
    width 100%

    p
      flex-wrap wrap

      input:not(:first-child)
        margin-top 0.5rem

    button
      width 100%

</style>
