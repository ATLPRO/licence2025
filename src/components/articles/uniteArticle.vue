<!-- pages/unites.vue -->
<script setup>
import { ref } from 'vue'

// Liste des unités enregistrées
const unites = ref([])

// Formulaire de création
const nouvelleUnite = ref({
  intitule: '',
  qte: '',
  pu: ''
})

// Fonction d'ajout
const ajouterUnite = () => {
  if (nouvelleUnite.value.intitule && nouvelleUnite.value.qte && nouvelleUnite.value.pu) {
    unites.value.push({ ...nouvelleUnite.value })
    // Réinitialiser le formulaire
    nouvelleUnite.value.intitule = ''
    nouvelleUnite.value.qte = ''
    nouvelleUnite.value.pu = ''
  }
}
</script>

<template>
  <div class="container py-4">
    <div class="card shadow mb-4">
      <div class="card-body">
        <h5 class="mb-3 text-primary">Ajouter une Unité d'Article</h5>
        <form @submit.prevent="ajouterUnite">
          <div class="row g-3">
            <div class="col-md-4">
              <label class="form-label">Intitulé</label>
              <input v-model="nouvelleUnite.intitule" type="text" class="form-control" required />
            </div>
            <div class="col-md-4">
              <label class="form-label">Quantité (QTE)</label>
              <input v-model="nouvelleUnite.qte" type="number" class="form-control" required />
            </div>
            <div class="col-md-4">
              <label class="form-label">Prix Unitaire (PU)</label>
              <input v-model="nouvelleUnite.pu" type="number" class="form-control" required />
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

    <!-- Tableau des unités -->
    <div class="card shadow">
      <div class="card-body">
        <h5 class="mb-3 text-primary">Liste des Unités</h5>
        <table class="table table-bordered table-striped">
          <thead class="table-light">
            <tr>
              <th>#</th>
              <th>Intitulé</th>
              <th>QTE</th>
              <th>PU</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(unite, index) in unites" :key="index">
              <td>{{ index + 1 }}</td>
              <td>{{ unite.intitule }}</td>
              <td>{{ unite.qte }}</td>
              <td>{{ unite.pu }} FCFA</td>
            </tr>
            <tr v-if="unites.length === 0">
              <td colspan="4" class="text-center text-muted">Aucune unité enregistrée</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>
