<template>
  <div id="app">
    <div v-for="p in original_packages">
      <h2>
        {{ p.name }} &mdash;
        <small>{{ p.title }}</small>
      </h2>
      <p>{{ p.description }}</p>
      <h3>Contributors</h3>
      <ul>
        <li v-for="c in p.contributors">{{c.person.name}} {{c.person.email}} [{{c.role}}] </li>
      </ul>
    </div>
  </div>
</template>

<script>
export default {
  props: ["original_packages"]
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
