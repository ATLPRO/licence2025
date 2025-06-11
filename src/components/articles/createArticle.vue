<script setup>
  import { ref,onMounted } from 'vue'
  import { useRouter } from 'vue-router'
  
  const famille=ref([])// Liste des familles récupérées depuis l’API
  const unite=ref([])// Liste des unites récupérées depuis l’API
  const reference=ref('')
  const designation=ref('')
  const type=ref('')
  const quantiteUnitaire=ref('')
  const prixAchat=ref('')
  const grammage=ref('')
  const prixVente=ref('')
  const stockInitial=ref('')
  const error = ref('')
const success = ref('')
  const idFamille = ref('')  // pour stocker l'ID sélectionné
  const idUnites=ref('')
  const idUnite = ref('')  // pour stocker l'ID sélectionné
  const qteA=ref(0)
  const puA=ref(0)
//charger les intitule de la famille dans le select famille
  async function chargerFamilles() {
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/famille/readAllfamille.php?host=localhost&dbname=licence2025&username=root&password=')
    if (!res.ok) throw new Error("Erreur serveur")
    famille.value = await res.json()
  } catch (err) {
    error.value = "Impossible de charger les familles d'articles"
    console.error(err)
  }
}
//charger les unites dans le select 
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
onMounted(() => {
  chargerFamilles()
  chargerUnites()
  genererReferenceArt()
  //console.log("article",idFamille)
})
function renseignerConditionnement() {
  const uniteChoisie = unite.value.find(u => u.idU == idUnite.value)
  if (uniteChoisie) {
    qteA.value = uniteChoisie.QteU
    puA.value = uniteChoisie.PuU
  } else {
    qteA.value = 0
    puA.value = 0
  }
}
//genere le nemero de commande automatiquement
async function genererReferenceArt() {
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/article/genererRefArt.php?host=localhost&dbname=licence2025&username=root&password=');
    const data = await res.json();
    reference.value = data.refArt;
  } catch (err) {
    console.error('Erreur lors de la génération du numéro :', err);
  }
}
//ajout dans article
async function enregistrerArticle() {
   error.value = ''
  success.value = ''
  if (!reference.value || !designation.value || quantiteUnitaire.value==='' || stockInitial.value==='' || !grammage.value || prixAchat.value===''  || !type.value ) {
    error.value = "Tous les champs sont requis."
    return
  }
  const payload = {
    refArt:reference.value,
    desArt: designation.value,
    QteUArt: quantiteUnitaire.value,
    grammage: grammage.value,
    pA: prixAchat.value,
    PV:prixVente.value,
    typeArt:type.value,
    stockMin:stockInitial.value,
    idFam:idFamille.value,
  }
  try {
    const resArticle = await fetch('http://localhost/apiLicence2025/controller/article/createarticle.php?host=localhost&dbname=licence2025&username=root&password=', {

      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload),
    })

    const data = await resArticle.json()
    console.log("api",data)
    if (resArticle.ok && data.idArt) {
       const idArt = data.idArt
      //creer les entrer dans avoir
      const avoirpayload = {
    idArt,
    idU: idUnite.value,
    qteA: qteA.value,
    puA: puA.value,
  }
    const resAvoir = await fetch('http://localhost/apiLicence2025/controller/avoir/createavoir.php?host=localhost&dbname=licence2025&username=root&password=', {

      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(avoirpayload),
    })
     const dataAvoir = await resAvoir.json()
      if (resAvoir.ok) {
        alert('✅ Article enregistrer avec succes');
        setTimeout(() => {
          router.push('/articles')
        }, 1500)
      } else {
        error.value = dataAvoir.message || "Erreur lors de l'enregistrement dans avoir."
      }
    } else {
      error.value = data.message || "Erreur lors de la création de l'article."
    }
  } catch (e) {
    error.value = "Erreur réseau ou serveur indisponible."
    console.error(e)
  }
}
//ajout dans avoir

//pour enregistrer un article
 function handleSubmit() {
 enregistrerArticle()
}
 
  </script>

<template>
    <div class="container py-4">
      <div class="card shadow">
        <!-- <div class="card-header bg-primary text-white">
          <h5 class="mb-0">Ajouter un Article</h5>
        </div> -->
        <div class="card-body">
          <form @submit.prevent="handleSubmit">
            <!-- Afficher l'erreur ou le succes selon le cas -->
      <div v-if="error" class="alert alert-danger">{{ error }}</div>
      <div v-if="success" class="alert alert-success">{{ success }}</div>
            <div class="row g-3">
              <div class="col-md-4">
                <label for="reference" class="form-label">Référence*</label>
                <input v-model="reference" type="text" class="form-control" id="reference" disabled required />
              </div>
              <div class="col-md-4">
                <label for="designation" class="form-label">Désignation*</label>
                <input v-model="designation" type="text" class="form-control" id="designation" required />
              </div>
              <div class="col-md-4">
                <label for="quantiteUnitaire" class="form-label">Quantité Unitaire*</label>
                <input v-model="quantiteUnitaire" type="number" class="form-control" id="quantiteUnitaire" required />
              </div>
              <div class="col-md-4">
                <label for="unite" class="form-label">Grammage*</label>
                <input v-model="grammage" type="text" class="form-control" id="grammage" required />
              </div>
              <div class="col-md-4">
                <label for="prixAchat" class="form-label">Prix d'achat(FCFA)*</label>
                <input v-model="prixAchat" type="number" class="form-control" id="prixAchat" required />
              </div>
             
              <div class="col-md-4">
                <label for="prixVente" class="form-label">Prix de vente(FCFA)</label>
                <input v-model="prixVente" type="number" class="form-control" id="prixVente"  />
              </div>
              <div class="col-md-4">
                <label for="type" class="form-label">Type*</label>
                <select v-model="type" class="form-select" required>
              <option value="produit fini">Produit fini</option>
              <option value="matiere premiere">Matiere premiere</option>
              <option value="divers">Divers</option>
                </select>  
              </div>
              <div class="col-md-4">
                <label for="famille" class="form-label">Famille*</label>
                <select v-model="idFamille" class="form-select" required>
                  <option value="">-- Sélectionner une famille --</option>
                  <option v-for="f in famille" 
                  :key="f.idFam" 
                  :value="f.idFam">
                     {{ f.intituleFam }}
                  </option>
                 </select>
              </div>
              
              <div class="col-md-4">
                <label for="stockInitial" class="form-label">Stock initial</label>
                <input v-model="stockInitial" type="number" class="form-control" id="stockInitial" required />
     
              </div>
            </div>
              <!-- === Partie 2 : Conditionnement === -->
             <h5 class="text-success mt-4">Conditionnement</h5>
          <div class="row g-3">
            <div class="col-md-4">
              <label for="unite" class="form-label">Unité*</label>
              <select v-model="idUnite" @change="renseignerConditionnement" class="form-select" required>
                <option value="">-- Sélectionner une unité --</option>
                <option v-for="u in unite" :key="u.idU" :value="u.idU">
                  {{ u.intituleU }}
                </option>
              </select>
            </div>
            <div class="col-md-4">
              <label for="qteA" class="form-label">Quantité </label>
              <input v-model="qteA" type="number" min="0" class="form-control" id="qteA"  />
            </div>
            <div class="col-md-4">
              <label for="puA" class="form-label">Prix unitaire (conditionné)</label>
              <input v-model="puA" type="number" min="0" class="form-control" id="puA"  />
            </div>
          </div>
            <div class="mt-4 d-flex justify-content-between">
              <button type="submit" class="btn btn-success">
                <i class="bi bi-check-circle me-1"></i> Ajouter
              </button>
              <button @click="$emit('close')"  class="btn btn-secondary">
                <i class="bi bi-x-circle me-1"></i> Annuler
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </template>
  
  
  