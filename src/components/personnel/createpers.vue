<script setup>
import { ref, onMounted } from 'vue'

const matriculePers = ref('')
const nompers = ref('')
const prenompers = ref('')
const datenaispers = ref('')
const lieunaispers = ref('')
const numtelpers = ref('')
const numcnipers = ref('')
const datevalidite = ref('')
const sexepers = ref('')
const statutpers = ref('')
const idfonc = ref('')
const idserv = ref('')
const message = ref('')

const fonction = ref([])
const service = ref([])

onMounted(() => {
  chargerFonction()
  chargerService()
})

//charger les fonction 
async function chargerFonction() {
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/fonction/readfonction.php?host=localhost&dbname=licence2025&username=root&password=')
    if (!res.ok) throw new Error("Erreur serveur")
    fonction.value = await res.json()
  } catch (err) {
    message.value = "Impossible de charger les fonctions"
    console.error(err)
  }
}

async function chargerService() {
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/service/readservice.php?host=localhost&dbname=licence2025&username=root&password=')
    if (!res.ok) throw new Error("Erreur serveur")
    service.value = await res.json()
  } catch (err) {
    message.value = "Impossible de charger les services"
    console.error(err)
  }
}
const ajouterPersonnel = async () => {
  const data = {
    matriculePers: matriculePers.value,
    nompers: nompers.value,
    prenompers: prenompers.value,
    datenaispers: datenaispers.value,
    lieunaispers: lieunaispers.value,
    numtelpers: numtelpers.value,
    numcnipers: numcnipers.value,
    datevalidite: datevalidite.value,
    sexepers: sexepers.value,
    statutpers: statutpers.value,
    idfonc: idfonc.value,
    idserv: idserv.value
  }

  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/personnel/addpersonnel.php?host=localhost&dbname=licence2025&username=root&password=', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    })

    const result = await res.json()
    message.value = result.message || 'Personnel ajouté'
    resetForm()
  } catch (err) {
    message.value = 'Erreur lors de l’enregistrement'
    console.error(err)
  }
}

const resetForm = () => {
  matriculePers.value = ''
  nompers.value = ''
  prenompers.value = ''
  datenaispers.value = ''
  lieunaispers.value = ''
  numtelpers.value = ''
  numcnipers.value = ''
  datevalidite.value = ''
  sexepers.value = ''
  statutpers.value = ''
  idfonc.value = ''
  idserv.value = ''
}
</script>


<template>
  <div class="container mt-4">
    <div class="card shadow">
      <div class="card-body">
        <form @submit.prevent="ajouterPersonnel">
          <div class="row g-3">
            <div class="col-md-4">
              <label class="form-label">Matricule*</label>
              <input v-model="matriculePers" class="form-control" required />
            </div>
            <div class="col-md-4">
              <label class="form-label">Nom*</label>
              <input v-model="nompers" class="form-control" required />
            </div>
            <div class="col-md-4">
              <label class="form-label">Prénom</label>
              <input v-model="prenompers" class="form-control" />
            </div>
            <div class="col-md-4">
              <label class="form-label">Date de naissance</label>
              <input v-model="datenaispers" type="date" class="form-control" />
            </div>
            <div class="col-md-4">
              <label class="form-label">Lieu de naissance</label>
              <input v-model="lieunaispers" class="form-control" />
            </div>
            <div class="col-md-4">
              <label class="form-label">Téléphone</label>
              <input v-model="numtelpers" class="form-control" />
            </div>
            <div class="col-md-4">
              <label class="form-label">Numéro CNI</label>
              <input v-model="numcnipers" class="form-control" />
            </div>
            <div class="col-md-4">
              <label class="form-label">Date validité CNI</label>
              <input v-model="datevalidite" type="date" class="form-control" />
            </div>
            <div class="col-md-4">
              <label class="form-label">Sexe</label>
              <select v-model="sexepers" class="form-select">
                <option value="">-- Sélectionner --</option>
                <option value="M">Masculin</option>
                <option value="F">Féminin</option>
              </select>
            </div>
            <div class="col-md-4">
              <label class="form-label">Statut</label>
              <input v-model="statutpers" class="form-control" />
            </div>
            <div class="col-md-4">
              <label class="form-label">Fonction</label>
              <select v-model="idfonc" class="form-select" required>
                <option value="">-- Sélectionner une fonction --</option>
                <option v-for="f in fonction" :key="f.idfonc" :value="f.idfonc">
                  {{ f.intituleFonc }}
                </option>
              </select>
            </div>
            <div class="col-md-4">
              <label class="form-label">Service</label>
              <select v-model="idserv" class="form-select" required>
                <option value="">-- Sélectionner un service --</option>
                <option v-for="s in service" :key="s.idserv" :value="s.idserv">
                  {{ s.intituleServ }}
                </option>
              </select>
            </div>
          </div>

          <div class="mt-4 d-flex justify-content-between">
            <button type="submit" class="btn btn-success">Enregistrer</button>
            <button type="button" @click="resetForm" class="btn btn-secondary">Réinitialiser</button>
          </div>

          <div v-if="message" class="alert alert-info mt-3">{{ message }}</div>
        </form>
      </div>
    </div>
  </div>
</template>

