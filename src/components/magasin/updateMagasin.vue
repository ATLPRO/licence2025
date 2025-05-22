<script setup>
import { ref, onMounted, watch } from 'vue'

const props = defineProps({
  codeMag: String
})

const nom = ref('')
const adresse = ref('')
const telephone = ref('')
const type = ref('')
const error = ref('')
const success = ref('')

// Fonction pour charger le magasin
async function chargerMagasin(code) {
  if (!code) return
  try {
    const res = await fetch(`http://localhost/apiLicence2025/controller/magasin/getOneMagasin.php?codeMag=${code}&host=localhost&dbname=licence2025&username=root&password=`)
    const data = await res.json()
    console.log("Données chargées :", data)
    if (res.ok && data) {
      nom.value = data.nomMag
      adresse.value = data.adresseMag
      telephone.value = data.telMag
      type.value = data.typeMag
    } else {
      error.value = "Erreur de chargement du magasin"
    }
  } catch (e) {
    error.value = "Erreur réseau"
  }
}

// Charger dès que codeMag change
watch(() => props.codeMag, (newCode) => {
  chargerMagasin(newCode)
}, { immediate: true })

// Soumettre la modification
const handleSubmit = async () => {
  error.value = ''
  success.value = ''
  try {
    const payload = {
      codeMag:props.codeMag,
      nomMag: nom.value,
      adresseMag: adresse.value,
      telMag: telephone.value,
      typeMag: type.value
    }
    const res = await fetch(`http://localhost/apiLicence2025/controller/magasin/updateMagasin.php?host=localhost&dbname=licence2025&username=root&password=`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    })
    const data = await res.json()
    console.log("Nouvelle donnees : ", data)
    if (res.ok && data.success) {
      success.value = data.message
      setTimeout(() => {
        router.push('/magasin')
      }, 1500)
    } else {
      error.value = data.message || "Échec de la modification"
    }
  } catch (e) {
    console.error("Erreur fetch :", e)
  error.value = "Erreur réseau"
  }
}
</script>


<template>
  <div class="container py-4">
    <div class="card shadow">
      <div class="card-body">
        <form @submit.prevent="handleSubmit">
          <div class="row g-3">
            <div class="col-md-6">
              <label class="form-label">Code*</label>
              <input :value="codeMag" type="text" class="form-control" readonly />
            </div>
            <div class="col-md-6">
              <label class="form-label">Nom*</label>
              <input v-model="nom" type="text" class="form-control" required />
            </div>
            <div class="col-md-6">
              <label class="form-label">Téléphone*</label>
              <input v-model="telephone" type="text" class="form-control" required />
            </div>
            <div class="col-md-6">
              <label class="form-label">Adresse*</label>
              <input v-model="adresse" type="text" class="form-control" required />
            </div>
            <div class="col-md-6">
              <label class="form-label">Type*</label>
              <select v-model="type" class="form-select" required>
                <option value="produit fini">Produit fini</option>
                <option value="matiere premiere">Matière première</option>
                <option value="divers">Divers</option>
              </select>
            </div>
            <div v-if="error" class="alert alert-danger">{{ error }}</div>
            <div v-if="success" class="alert alert-success">{{ success }}</div>
          </div>

          <div class="mt-4 d-flex justify-content-between">
            <button type="submit" class="btn btn-primary">
              <i class="bi bi-check-circle me-1"></i> Sauvegarder
            </button>
            <router-link to="/magasin" class="btn btn-secondary">
              <i class="bi bi-x-circle me-1"></i> Annuler
            </router-link>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>
