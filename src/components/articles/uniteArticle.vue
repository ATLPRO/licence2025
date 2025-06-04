<!-- pages/unites.vue -->
<script setup>
import { ref,onMounted } from 'vue'
import { useRouter } from 'vue-router'


const unite = ref([])

const intitule = ref('') 
const qte=ref('')
const pu=ref('')
const error = ref('')
const success = ref('')
const router = useRouter()

 async function ajouterUnite() {
  error.value = ''
  success.value = ''
  if (!intitule.value || !qte.value || !pu.value) {
    error.value = "Tous les champs sont requis."
    return
  }
  const payload = {
    intituleU:intitule.value,
    QteU: qte.value,
    PuU:pu.value,
  }
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/unite/adduniteart.php?host=localhost&dbname=licence2025&username=root&password=', {

      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload),
    })

    const data = await res.json()

    if (res.ok) {
      success.value = data.message || "Unité crée avec succès."
      await chargerUnites() // ✅ Recharge la liste automatiquement
      // Petite pause avant redirection
      setTimeout(() => {
        intitule.value=''
        qte.value=''
        pu.value=''
      }, 1500)
    } else {
      error.value = data.message || "Erreur lors de l'insertion."
    }
  } catch (e) {
    error.value = "Erreur réseau ou serveur indisponible."
    console.error(e)
  }
}
//recharger les unites apres ajout reussi
async function chargerUnites() {
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/unite/readunite.php?host=localhost&dbname=licence2025&username=root&password=')
    if (!res.ok) throw new Error("Erreur serveur")
    unite.value = await res.json()
  } catch (err) {
    error.value = "Impossible de charger les unites d'articles"
    console.error(err)
  }
}

// Fonction pour afficher le unites
onMounted(chargerUnites(), async () => {
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/unite/readunite.php?host=localhost&dbname=licence2025&username=root&password=')
    if (!res.ok) throw new Error("Erreur serveur")
    unite.value = await res.json()
    //famille.value = famille.value.filter(m => m)
  } catch (err) {
    error.value = "Impossible de charger les unités d'articles"
    console.error(err)
  }
})
 //supprimer l'unite
async function deleteUnite(idU) {
  if (!confirm("Confirmer la suppression de cette unité?")) return;
  try {
    const res = await fetch(`http://localhost/apiLicence2025/controller/unite/supprimerVirtuellement.php?host=localhost&dbname=licence2025&username=root&password=`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ idU })
    });
    const result = await res.json();
    if (result.success) {
      unite.value = unite.value.filter(f => f.idU !== idU);
      alert(result.message);
    } else {
      alert(result.message);
    }
  } catch (err) {
    console.error(err);
    alert("Erreur de suppression.");
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
              <input v-model="intitule" type="text" class="form-control" required />
            </div>
            <div class="col-md-4">
              <label class="form-label">Quantité (QTE)</label>
              <input v-model="qte" type="number" class="form-control" required />
            </div>
            <div class="col-md-4">
              <label class="form-label">Prix Unitaire (PU)</label>
              <input v-model="pu" type="number" class="form-control" required />
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
              <th>PU(FCFA)</th>
               <th style="max-width: 40px;" class="text-center">Action</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(unite, index) in unite" :key="index">
              <td>{{ index + 1 }}</td>
              <td>{{ unite.intituleU }}</td>
              <td>{{ unite.QteU }}</td>
              <td>{{ unite.PuU }} </td>
              <td>
                <button @click="deleteUnite(unite.idU)" class="btn btn-sm text-danger border-0 text-center" title="Supprimer">
                  <i class="bi bi-trash"></i>
                </button>
              </td>
            </tr>
            <tr v-if="unite.length === 0">
              <td colspan="4" class="text-center text-muted">Aucune unité enregistrée</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>
