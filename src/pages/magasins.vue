<script setup>
import createMagasin from '@/components/magasin/createMagasin.vue';
import updateMagasin from '@/components/magasin/updateMagasin.vue';

import { ref, onMounted } from 'vue'

const magasins = ref([])
const error = ref('')
const magasinAEditer = ref(null)

function editMagasin(mag) {
  magasinAEditer.value = mag
}
//Afficher les magasins
onMounted(async () => {
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/magasin/getMagasins.php?host=localhost&dbname=licence2025&username=root&password=')
    if (!res.ok) throw new Error("Erreur serveur")
    magasins.value = await res.json()
  } catch (err) {
    error.value = "Impossible de charger les magasins"
    console.error(err)
  }
})

//supprimer le magasin
async function deleteMagasin(codeMag) {
  if (!confirm("Confirmer la suppression du magasin ?")) return;
  try {
    const res = await fetch(`http://localhost/apiLicence2025/controller/magasin/deleteMagasin.php?host=localhost&dbname=licence2025&username=root&password=`, {
      method: 'DELETE',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ codeMag })
    });
    const result = await res.json();
    if (result.success) {
      magasins.value = magasins.value.filter(m => m.codeMag !== codeMag);
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
  <div class="container-fluid py-3">
    <!-- Titre et bouton Actualiser -->
    <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap">
      <h4 class="text-primary">Gestion des magasins</h4>
      <router-link to="/acceuil">  <button class="btn btn-danger">
        <i class="bi bi-box-arrow-left me-1"></i> Quitter
      </button>
    </router-link>
    </div>

    <!-- Boutons d'action secondaires et recherche -->
    <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-2">
      <div class="btn-group">
        
        <button class="btn btn-secondary btn-sm"  data-bs-toggle="modal" data-bs-target="#modalAjout">Nouveau</button>
        <!-- <button  class="btn btn-secondary btn-sm"   data-bs-toggle="modal" data-bs-target="#modalModifier">Modifier</button>
        <button @click="deleteMagasin(mag.codeMag)" class="btn btn-secondary btn-sm">Supprimer</button> -->
      </div>
      <div class="input-group" style="max-width: 200px;">
        <input type="text" class="form-control form-control-sm" placeholder="Rechercher...">
        <button class="btn btn-outline-secondary btn-sm"><i class="bi bi-search"></i></button>
      </div>
    </div>

    <!-- Tableau -->
    <div class="table-responsive">
      <div v-if="error" class="alert alert-danger">{{ error }}</div>
      <table v-if="magasins.length" class="table table-hover table-bordered align-middle">
        <thead class="table-primary text-center">
          <tr>
            <th>Code</th>
            <th style="min-width: 130px;">Nom</th>
            <th style="min-width: 130px;">Adresse</th>
            <th style="min-width: 130px;">Téléphone</th>
            <th style="min-width: 130px;">Type</th>
            <th style="min-width: 130px;" class="text-center">Action</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="mag in magasins" :key="mag.codeMag">
          <td>{{ mag.codeMag }}</td>
          <td>{{ mag.nomMag }}</td>
          <td>{{ mag.adresseMag }}</td>
          <td>{{ mag.telMag }}</td>
          <td>{{ mag.typeMag }}</td>
            <td class="text-center">
              <i class="bi bi-plus-circle text-success border-0 me-3" role="button" title="Nouveau"
              data-bs-toggle="modal" data-bs-target="#modalAjout"></i>
              <button @click="editMagasin(mag)" class="btn btn-sm text-warning border-0 me-1" title="Modifier">
                <i class="bi bi-pencil-square" data-bs-toggle="modal" data-bs-target="#modalModifier"></i>
              </button>
              <button @click="deleteMagasin(mag.codeMag)" class="btn btn-sm text-danger border-0" title="Supprimer">
                <i class="bi bi-trash"></i>
              </button>
            </td>
          </tr>
        </tbody>
      </table>
      <div v-else class="alert alert-info">Aucun magasin trouvé.</div>
    </div>

  </div>

   <!-- Modal d’ajout -->
<div class="modal fade" id="modalAjout" tabindex="-1" aria-labelledby="modalAjoutLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header bg-primary text-white ">
        <h5 class="modal-title" id="modalAjoutLabel">Ajouter un magasin</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fermer"></button>
      </div>
      <div class="modal-body">
       <createMagasin />
      </div>
    </div>
  </div>
</div>
 <!-- Modal de modification -->
 <div class="modal fade" id="modalModifier" tabindex="-1" aria-labelledby="modalAjoutLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header bg-primary text-white ">
        <h5 class="modal-title" id="modalAjoutLabel">Modifier un magasin</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fermer"></button>
      </div>
      <div class="modal-body">
       <updateMagasin :codeMag="magasinAEditer?.codeMag" v-if="magasinAEditer" />
      </div>
    </div>
  </div>
</div>
</template>


<style scoped>
@media (max-width: 768px) {
  .table th, .table td {
    font-size: 0.85rem;
  }
}
</style>
