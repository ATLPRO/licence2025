<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const refArt = route.params.refArt

const article = ref({})
const composants = ref([])

/* onMounted(async () => {
  const res1 = await fetch(`http://localhost/api/article/getArticle.php?refArt=${refArt}`)
  article.value = await res1.json()

  const res2 = await fetch(`http://localhost/api/article/getComposants.php?refArt=${refArt}`)
  composants.value = await res2.json()
}) */
</script>

<template>
  <div class="container mt-3">
    <!-- En-tête de l'article -->
    <div class="card mb-3">
      <div class="card-header bg-primary text-white">
        Détails de l'article produit fini
      </div>
      <div class="card-body row">
        <div class="col-md-4"><strong>Référence :</strong> {{ article.refArt }}</div>
        <div class="col-md-4"><strong>Désignation :</strong> {{ article.desArt }}</div>
        <div class="col-md-4"><strong>Type :</strong> {{ article.typeArt }}</div>
        <div class="col-md-4"><strong>Famille :</strong> {{ article.intituleFam }}</div>
        <div class="col-md-4"><strong>Grammage :</strong> {{ article.grammage }}</div>
        <div class="col-md-4"><strong>Stock initial :</strong> {{ article.stockMin }}</div>
      </div>
    </div>

    <!-- Corps : composants (matières premières) -->
    <div class="card">
      <div class="card-header bg-secondary text-white">
        Composants du produit fini
      </div>
      <div class="card-body">
        <table class="table table-bordered table-sm">
          <thead>
            <tr>
              <th>Matière première</th>
              <th>Quantité</th>
              <th>Unité</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(comp, i) in composants" :key="i">
              <td>{{ comp.designation }}</td>
              <td>{{ comp.qte }}</td>
              <td>{{ comp.unite }}</td>
            </tr>
            <tr v-if="composants.length === 0">
              <td colspan="3" class="text-center text-muted">Aucun composant défini</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>


