<script setup>
import { reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ref, onMounted } from 'vue'

const props = defineProps({
  codefour: String
})

onMounted(() => {
  if (props.codefour) {
    fetchData(props.codefour)
  }
})

function fetchData(code) {
  // Charger les données du fournisseur avec ce code...
}

const router = useRouter()
const fournisseur = reactive({
  codefour: '',
  nom: '',
  prenom: '',
  tel1: '',
  tel2: '',
  adresse: '',
  ca: '',
  soldeInitial: '',
  soldeFinal: ''
})

const handleSubmit = () => {
  console.log('Fournisseur enregistré :', fournisseur)
  // Ici, tu pourrais envoyer les données vers une API ou les stocker
  router.push('/fournisseurs') // redirige vers la page liste des fournisseurs
}
</script>

<template>
  <div class="container py-4">
    <div class="card shadow">
      <!-- <div class="card-header bg-primary text-white">
        <h5 class="mb-0">Modifier un Fournisseur</h5>
      </div> -->
      <div class="card-body">
        <form @submit.prevent="handleSubmit">
          <div class="row g-3">
            <div class="col-md-4">
              <label class="form-label">Code Fournisseur</label>
              <input v-model="fournisseur.codefour" type="text" class="form-control" required />
            </div>
            <div class="col-md-4">
              <label class="form-label">Nom</label>
              <input v-model="fournisseur.nom" type="text" class="form-control" required />
            </div>
            <div class="col-md-4">
              <label class="form-label">Prénom</label>
              <input v-model="fournisseur.prenom" type="text" class="form-control" required />
            </div>
            <div class="col-md-4">
              <label class="form-label">Téléphone 1</label>
              <input v-model="fournisseur.tel1" type="tel" class="form-control" />
            </div>
            <div class="col-md-4">
              <label class="form-label">Téléphone 2</label>
              <input v-model="fournisseur.tel2" type="tel" class="form-control" />
            </div>
            <div class="col-md-4">
              <label class="form-label">Adresse</label>
              <input v-model="fournisseur.adresse" type="text" class="form-control" />
            </div>
            <div class="col-md-4">
              <label class="form-label">Chiffre d'affaires</label>
              <input v-model="fournisseur.ca" type="number" min="0" class="form-control" />
            </div>
            <div class="col-md-4">
              <label class="form-label">Solde initial</label>
              <input v-model="fournisseur.soldeInitial" type="number" min="0" class="form-control" />
            </div>
            <div class="col-md-4">
              <label class="form-label">Solde final</label>
              <input v-model="fournisseur.soldeFinal" type="number" min="0" class="form-control" />
            </div>
          </div>

          <div class="mt-4 d-flex justify-content-between">
            <button type="submit" class="btn btn-success">
              <i class="bi bi-check-circle me-1"></i> Enregistrer
            </button>
            <button @click="$emit('close')" class="btn btn-secondary">
              <i class="bi bi-x-circle me-1"></i> Annuler
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>
