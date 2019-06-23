import Vue from 'vue/dist/vue.esm'
import App from '../app.vue'

document.addEventListener('turbolinks:load', function() {
  var element = document.querySelector('#packages');
  if (element != undefined) {
    const app = new Vue({
      el: element,
      data: {
        packages: JSON.parse(element.dataset.packages)
      },
      template: "<App :original_packages='packages' />",
      components: { App }
    });
  }
});
