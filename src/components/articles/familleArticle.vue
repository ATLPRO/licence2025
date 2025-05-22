<!-- pages/familles.vue -->
<script setup>
import { ref } from 'vue'

// Liste des familles enregistrées
const familles = ref([])

// Formulaire de création
const nouvelleFamille = ref({
  intitule: '',
  abreviation: ''
})

// Fonction d'ajout
const ajouterFamille = () => {
  if (nouvelleFamille.value.intitule && nouvelleFamille.value.abreviation) {
    familles.value.push({ ...nouvelleFamille.value })
    // Réinitialiser le formulaire
    nouvelleFamille.value.intitule = ''
    nouvelleFamille.value.abreviation = ''
  }
}
</script>

<template>
  <div class="container py-4">
    <div class="card shadow mb-4">
      <div class="card-body">
        <h5 class="mb-3 text-primary">Ajouter une Famille d'Articles</h5>
        <form @submit.prevent="ajouterFamille">
          <div class="row g-3">
            <div class="col-md-6">
              <label class="form-label">Intitulé de la famille</label>
              <input v-model="nouvelleFamille.intitule" type="text" class="form-control" required />
            </div>
            <div class="col-md-6">
              <label class="form-label">Abréviation</label>
              <input v-model="nouvelleFamille.abreviation" type="text" class="form-control" required />
            </div>
          </div>
          <div class="mt-3">
            <button type="submit" class="btn btn-success">
              <i class="bi bi-plus-circle me-1"></i> Ajouter
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- Tableau des familles -->
    <div class="card shadow">
      <div class="card-body">
        <h5 class="mb-3 text-primary">Liste des Familles</h5>
        <table class="table table-bordered table-striped">
          <thead class="table-light">
            <tr>
              <th>#</th>
              <th>Intitulé</th>
              <th>Abréviation</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(famille, index) in familles" :key="index">
              <td>{{ index + 1 }}</td>
              <td>{{ famille.intitule }}</td>
              <td>{{ famille.abreviation }}</td>
            </tr>
            <tr v-if="familles.length === 0">
              <td colspan="3" class="text-center text-muted">Aucune famille enregistrée</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>
