<!-- pages/familles.vue -->
<script setup>
import { ref,onMounted } from 'vue'
import { useRouter } from 'vue-router'

// Liste des fonction enregistrées
const fonction = ref([])

const intitule=ref('')
const error = ref('')
const success = ref('')
const router = useRouter()

 async function ajouterFonction() {
  error.value = ''
  success.value = ''
  if ( !intitule.value) {
    error.value = "Tous le champs est requis."
    return
  }
  const payload = {
    intituleFonc: intitule.value,
  }
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/fonction/addfonction.php?host=localhost&dbname=licence2025&username=root&password=', {

      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload),
    })

    const data = await res.json()

    if (res.ok) {
      success.value = data.message || "Fonction crée avec succès."
      await chargerFonction() // ✅ Recharge la liste automatiquement
      // Petite pause avant redirection
      setTimeout(() => {
        intitule.value=''
        
      }, 1500)
    } else {
      error.value = data.message || "Erreur lors de l'insertion."
    }
  } catch (e) {
    error.value = "Erreur réseau ou serveur indisponible."
    console.error(e)
  }
}
//recharger les fonction apres ajout reussi
async function chargerFonction() {
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/fonction/readfonction.php?host=localhost&dbname=licence2025&username=root&password=')
    if (!res.ok) throw new Error("Erreur serveur")
    fonction.value = await res.json()
  } catch (err) {
    error.value = "Impossible de charger les fonctions"
    console.error(err)
  }
}

// Fonction pour afficher le familles
onMounted(chargerFonction(), async () => {
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/fonction/readfonction.php?host=localhost&dbname=licence2025&username=root&password=')
    if (!res.ok) throw new Error("Erreur serveur")
    fonction.value = await res.json()
    //famille.value = famille.value.filter(m => m)
  } catch (err) {
    error.value = "Impossible de charger les fonctions "
    console.error(err)
  }
})
</script>

<template>
  <div class="container py-4">
    <div class="card shadow mb-4">
      <div class="card-body">
        <h5 class="mb-3 text-primary">Ajouter une fonction </h5>
        <form @submit.prevent="ajouterFonction">
           <!-- Afficher l'erreur ou le succes selon le cas -->
      <div v-if="error" class="alert alert-danger">{{ error }}</div>
      <div v-if="success" class="alert alert-success">{{ success }}</div>
          <div class="row g-3">
            <div class="col-md-6">
              <label class="form-label">Intitulé de la fonction</label>
              <input v-model="intitule" type="text" class="form-control" required />
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
        <h5 class="mb-3 text-primary">Liste des fonctions</h5>
        <table class="table table-bordered table-striped">
          <thead class="table-light">
            <tr>
              <th>#</th> 
              <th>Intitulé fonction</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(fonction, index) in fonction" :key="index">
              <td>{{ index + 1 }}</td> 
              <td>{{ fonction.intituleFonc }}</td>
            </tr>
            <tr v-if="fonction.length === 0">
              <td colspan="3" class="text-center text-muted">Aucune fonction enregistrée</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>
