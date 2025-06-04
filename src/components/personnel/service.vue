<!-- pages/familles.vue -->
<script setup>
import { ref,onMounted } from 'vue'
import { useRouter } from 'vue-router'

// Liste des fonction enregistrées
const service = ref([])

const intitule=ref('')
const error = ref('')
const success = ref('')
const router = useRouter()

 async function ajouterService() {
  error.value = ''
  success.value = ''
  if ( !intitule.value) {
    error.value = "Tous le champs est requis."
    return
  }
  const payload = {
    intituleServ: intitule.value,
  }
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/service/addservice.php?host=localhost&dbname=licence2025&username=root&password=', {

      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload),
    })

    const data = await res.json()

    if (res.ok) {
      success.value = data.message || "Fonction crée avec succès."
      await chargerService() // ✅ Recharge la liste automatiquement
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
//recharger les service apres ajout reussi
async function chargerService() {
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/service/readservice.php?host=localhost&dbname=licence2025&username=root&password=')
    if (!res.ok) throw new Error("Erreur serveur")
    service.value = await res.json()
  } catch (err) {
    error.value = "Impossible de charger les services"
    console.error(err)
  }
}

// Fonction pour afficher le service
onMounted(chargerService(), async () => {
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/service/readservice.php?host=localhost&dbname=licence2025&username=root&password=')
    if (!res.ok) throw new Error("Erreur serveur")
    service.value = await res.json()
    //famille.value = famille.value.filter(m => m)
  } catch (err) {
    error.value = "Impossible de charger les services "
    console.error(err)
  }
})
</script>

<template>
  <div class="container py-4">
    <div class="card shadow mb-4">
      <div class="card-body">
        <h5 class="mb-3 text-primary">Ajouter un service </h5>
        <form @submit.prevent="ajouterService">
           <!-- Afficher l'erreur ou le succes selon le cas -->
      <div v-if="error" class="alert alert-danger">{{ error }}</div>
      <div v-if="success" class="alert alert-success">{{ success }}</div>
          <div class="row g-3">
            <div class="col-md-6">
              <label class="form-label">Intitulé du service</label>
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
        <h5 class="mb-3 text-primary">Liste des services</h5>
        <table class="table table-bordered table-striped">
          <thead class="table-light">
            <tr>
              <th>#</th> 
              <th>Intitulé service</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(service, index) in service" :key="index">
              <td>{{ index + 1 }}</td> 
              <td>{{ service.intituleServ }}</td>
            </tr>
            <tr v-if="service.length === 0">
              <td colspan="3" class="text-center text-muted">Aucun service enregistré</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>
