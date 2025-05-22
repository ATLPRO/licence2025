<script setup>
import { ref, reactive, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()

// Liste des articles disponibles (à remplacer plus tard par une API)
const articlesDisponibles = ref([
  { id: 1, nom: 'Article 1', prix: 1000 },
  { id: 2, nom: 'Article 2', prix: 2500 },
  { id: 3, nom: 'Article 3', prix: 1800 },
])

// Commande à modifier
const commande = reactive({
  numero: 'CMD-001',
  date: '2025-05-07',
  fournisseur: 'Fournisseur A',
  lignes: [
    { articleId: 1, quantite: 3, prixUnitaire: 1000 },
    { articleId: 2, quantite: 2, prixUnitaire: 2500 },
  ],
})

const ajouterLigne = () => {
  commande.lignes.push({ articleId: '', quantite: 1, prixUnitaire: 0 })
}

const supprimerLigne = (index) => {
  commande.lignes.splice(index, 1)
}

const totalLigne = (ligne) => ligne.quantite * ligne.prixUnitaire

const totalCommande = computed(() =>
  commande.lignes.reduce((total, ligne) => total + totalLigne(ligne), 0)
)

// Mise à jour automatique du prix unitaire selon l'article sélectionné
const updatePrix = (ligne) => {
  const article = articlesDisponibles.value.find(a => a.id === ligne.articleId)
  if (article) {
    ligne.prixUnitaire = article.prix
  }
}

const enregistrer = () => {
  console.log('Commande modifiée :', commande)
  router.push('/commandes')
}
</script>

<template>
  <div class="container mt-4">
    <h4 class="text-primary mb-4">Modifier la commande</h4>

    <!-- En-tête -->
    <div class="row g-3 mb-3">
      <div class="col-md-4">
        <label class="form-label">Numéro</label>
        <input v-model="commande.numero" type="text" class="form-control" disabled />
      </div>
      <div class="col-md-4">
        <label class="form-label">Date</label>
        <input v-model="commande.date" type="date" class="form-control" />
      </div>
      <div class="col-md-4">
        <label class="form-label">Fournisseur</label>
        <input v-model="commande.fournisseur" type="text" class="form-control" />
      </div>
    </div>

    <!-- Corps -->
    <h5 class="mt-4">Lignes de commande</h5>
    <table class="table table-bordered align-middle">
      <thead class="table-light">
        <tr>
          <th>Article</th>
          <th>Quantité</th>
          <th>Prix unitaire</th>
          <th>Total</th>
          <th>Action</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(ligne, index) in commande.lignes" :key="index">
          <td>
            <select v-model="ligne.articleId" @change="updatePrix(ligne)" class="form-select">
              <option value="">-- Choisir un article --</option>
              <option v-for="a in articlesDisponibles" :key="a.id" :value="a.id">
                {{ a.nom }}
              </option>
            </select>
          </td>
          <td>
            <input v-model.number="ligne.quantite" type="number" min="1" class="form-control" />
          </td>
          <td>
            <input v-model.number="ligne.prixUnitaire" type="number" min="0" class="form-control" />
          </td>
          <td>{{ totalLigne(ligne) }} FCFA</td>
          <td>
            <button class="btn btn-sm btn-danger" @click="supprimerLigne(index)">
              <i class="bi bi-trash"></i>
            </button>
          </td>
        </tr>
      </tbody>
    </table>

    <button class="btn btn-outline-primary mb-3" @click="ajouterLigne">
      <i class="bi bi-plus-circle"></i> Ajouter une ligne
    </button>

    <!-- Total -->
    <div class="text-end mt-4">
      <h5>Total général : {{ totalCommande }} FCFA</h5>
      <button class="btn btn-success me-2" @click="enregistrer">
        <i class="bi bi-save"></i> Enregistrer
      </button>
      <router-link to="commandes" class="btn btn-secondary">
        Annuler
      </router-link>
    </div>
  </div>
</template>
