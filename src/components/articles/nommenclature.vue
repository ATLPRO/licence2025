<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
 const emit = defineEmits(['close','refresh'])
const route = useRoute()
//const refArt = route.params.refArt

const article = ref({})
const matieres = ref([])
const composants = ref([])
// Props : reference de l'article passé par le parent
const props = defineProps({
  refArt: String,
  idArt:Number
})

const nouveauComp = ref({
     id: '', 
     qteA: '',
     puA: '', 
     intituleU: '' 
    })
// Chargement des données
async function chargerInfosArticle(refArt) {
  //console.log("Chargement des détails pour :", numcom)
  try {
    const res = await fetch(
      `http://localhost/apiLicence2025/controller/article/getRefDesTypeArt.php?host=localhost&dbname=licence2025&username=root&password=`
    ,{
      method:'POST',
       headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ refArt })
    });
    if (!res.ok) throw new Error('Erreur serveur')
    const data = await res.json()
    console.log('Données reçues :', data)
    // On suppose que les champs généraux (numcom, date...) sont les mêmes sur chaque ligne
    if (data.length > 0) {
      const entete = data[0]
      article.value = {
        refArt: entete.refArt,
        desArt: entete.desArt,
        typeArt: entete.typeArt,
        idArt:entete.idArt,
      }
       } 
    }catch (err) {
    console.error('Erreur chargement détail article :', err)
  }
}
async function compositionArticle() {
   try {
    const res = await fetch(
      `http://localhost/apiLicence2025/controller/article/compositionArticle.php?host=localhost&dbname=licence2025&username=root&password=`
    ,{
      method:'POST',
       headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ idArt: props.idArt })
    });
    if (!res.ok) throw new Error('Erreur serveur')
    const data = await res.json()
    console.log('Données reçues :', data)
    // On suppose que les champs généraux (numcom, date...) sont les mêmes sur chaque ligne
    composants.value = data.map(c => ({
      id:c.idArtFils,
    reference:  c.refArt  + " "+" "+ c.desArt,
    //designation:c.desArt,
    qteA:        c.qteN,
    puA:         c.puN,
   // montant:    (c.qteN * c.puN).toFixed(2),
    intituleU:      c.intituleU
  }))
       
    }catch (err) {
    console.error('Erreur chargement détail article :', err)
  }
}
 onMounted(async () => {
chargerInfosArticle(props.refArt)
  await compositionArticle(props.idArt)

  const res3 = await fetch('http://localhost/apiLicence2025/controller/article/getAllMatPre.php?host=localhost&dbname=licence2025&username=root&password=')
  matieres.value = await res3.json()
  console.log('Matières chargées :', matieres.value)
})
 //selection de matieres premieres et mise ajour des champs qte pu et unite
 // 🔁 Watcher : met à jour les champs quand on choisit une matière première
function miseAjourQtePrixUnite(nouveauComp){
    const articleChoisie = matieres.value.find(m => m.idArt == nouveauComp.id)
    if (articleChoisie) {
         nouveauComp.qteA = articleChoisie.qteA
    nouveauComp.puA = articleChoisie.puA
    nouveauComp.intituleU = articleChoisie.intituleU
    console.log('pu',nouveauComp.puA)
    console.log('qte',nouveauComp.qteA)
    }else{
        nouveauComp.qteA = 0
    nouveauComp.puA = 0
    nouveauComp.intituleU = ''
    }
}
function ajouterComposant() {
  const { id, qteA, puA, intituleU } = nouveauComp.value

  // Debug : voir les valeurs dans la console
  console.log('Valeur saisie:', nouveauComp.value)

  // Vérification des champs
  if (
    !id ||
    isNaN(parseFloat(qteA)) || parseFloat(qteA) <= 0 ||
    isNaN(parseFloat(puA)) || parseFloat(puA) <= 0 ||
    !intituleU.trim()
  ) {
    alert("Veuillez remplir tous les champs correctement.")
    return
  }

  // Doublon
  if (composants.value.find(c => c.id === id)) {
    alert("Cette matière première est déjà ajoutée.")
    return
  }

  // Ajout
  const matiere = matieres.value.find(m => m.idArt === id)
  composants.value.push({
    id,
    reference: matiere.reference,
    qteA,
    puA,
    intituleU
  })

  // Réinitialisation des champs
  nouveauComp.value = {
    id: '',
    qteA: '',
    puA: '',
    intituleU: ''
  }
}

function remplirChampsPourModification(index) {
  const comp = composants.value[index]

  nouveauComp.value.id = comp.id
  nouveauComp.value.qteA = comp.qteA
  nouveauComp.value.puA = comp.puA
  nouveauComp.value.intituleU = comp.intituleU
  
  composants.value.splice(index, 1)
}

function supprimerComposant(index) {
  composants.value.splice(index, 1)
}

async function enregistrerNomenclature() {
  const payload = {
    idArt: article.value.idArt,
    composants: composants.value.map(c => ({
      idArtFils: c.id,
      qteN: c.qteA,
      puN: c.puA
    }))
  }
console.log('Payload à envoyer :', payload)

  const nommer = await fetch('http://localhost/apiLicence2025/controller/nommer/createnommer.php?host=localhost&dbname=licence2025&username=root&password=', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload)
  })
if (!nommer.ok) {
  const err = await nommer.json()
  alert("Erreur serveur : " + err.message)
  return
}
const result = await nommer.json()
alert("Article  " + article.value.desArt + " nommé avec succès")
 emit('refresh')  // 🔄 Demande au parent de recharger la liste
        emit('close') // pas de router.push ici

}

</script>

<template>
  <div class="container mt-3">
    <!-- En-tête de l'article -->
    <div class="card mb-3">
      <div class="card-header bg-primary text-white">
        Définir la nomenclature de l'article "<strong>{{ article.desArt }}</strong>  "
      </div>
      <div class="card-body row">
        <div class="col-md-4"><strong>Référence :</strong> {{ article.refArt }}</div>
        <div class="col-md-4"><strong>Désignation :</strong> {{ article.desArt }}</div>
        <div class="col-md-4"><strong>Type :</strong> {{ article.typeArt }}</div>
      </div>
    </div>

    <!-- Formulaire d’ajout de composant -->
    <div class="mb-3 row align-items-end">
      <div class="col-md-3">
        <label class="form-label">Matière première</label>
        <select v-model="nouveauComp.id" class="form-select" @change="miseAjourQtePrixUnite(nouveauComp)">
          <option disabled value="">-- Choisir --</option>
          <option v-for="mat in matieres" 
          :key="mat.idArt" :value="mat.idArt" >
            {{ mat.reference }}
        </option>
        </select>
      </div>
      <div class="col-md-2">
        <label class="form-label">Quantité</label>
        <input type="number" v-model="nouveauComp.qteA" min="0" step="any" class="form-control" required />
      </div>
       <div class="col-md-3">
        <label class="form-label">Prix unitaire</label>
        <input type="number" v-model="nouveauComp.puA" min="0" step="any" class="form-control" required />
      </div>
      <div class="col-md-2">
        <label class="form-label">Unité</label>
        <input type="text" v-model="nouveauComp.intituleU" class="form-control" readonly required/>
      </div>
      <div class="col-md-2">
        <button class="btn btn-success mt-3" @click="ajouterComposant">Ajouter</button>
      </div>
    </div>

    <!-- Liste des composants -->
    <div class="card">
      <div class="card-header bg-secondary text-white">
        Composants existants
      </div>
      <div class="card-body">
        <table class="table table-bordered table-sm">
          <thead>
            <tr>
              <th>Matière première</th>
              <th>Quantité</th>
              <th>Prix unitaire</th>
              <th>Unité</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(comp, i) in composants" :key="i">
              <td>{{ comp.reference }}</td>
              <td>{{ comp.qteA }}</td>
              <td>{{ comp.puA }}</td>
              <td>{{ comp.intituleU }}</td>
              <td>
                <button class="btn btn-sm btn-danger" @click="supprimerComposant(i)">X</button>
                <button @click="remplirChampsPourModification(i)" class="btn btn-sm text-warning border-0 me-1" title="Modifier">
                  <i class="bi bi-pencil-square"></i>
                </button>
              </td>
              </tr>
            <tr v-if="composants.length === 0">
              <td colspan="5" class="text-center text-muted">Aucun composant défini</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Bouton enregistrer -->
    <div class="mt-3 text-end">
      <button class="btn btn-primary" @click="enregistrerNomenclature">Enregistrer</button>
    </div>
  </div>
</template>


