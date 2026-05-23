Sandbox SoftPay
DEFINITION
GENERATION DU TOKEN DE PAIEMENT
EFFECTUER UN PAIEMENT

DEFINITION
Afin de tester notre API SoftPay, vous devrez générer:

Un token de paiement de test : il vous fournira un token de facture pour le paiement;
Vos clés d'API : seront utiliséss pour remplir vos en-têtes;
Au moins un compte client fictif ou un compte test : nous aurons besoin de son adresse email et du numéro de téléphone;

GENERATION DU TOKEN DE PAIEMENT
SANDBOX INVOICE TOKEN
https://app.paydunya.com/sandbox-api/v1/checkout-invoice/create
Copy


REQUÊTE HTTP POST

curl -H "Content-Type: application/json" \
-H "PAYDUNYA-MASTER-KEY: wQzk9ZwR-Qq9m-0hD0-zpud-je5coGC3FHKW" \
-H "PAYDUNYA-PRIVATE-KEY: test_private_rMIdJM3PLLhLjyArx9tF3VURAF5" \
-H "PAYDUNYA-TOKEN: IivOiOxGJuWhc5znlIiK" \
-X POST -d '{"invoice": {"total_amount": 5000, "description": "Chaussure VANS dernier modèle"},"store": {"name": "Magasin le Choco"}}' \
"https://app.paydunya.com/sandbox-api/v1/checkout-invoice/create"
Copy
REPONSE ATTENDUE

{
    "response_code":"00",
    "response_text":"https://app.paydunya.com/sandbox-checkout/invoice/test_6BaZCm7FXS",
    "description":"Checkout Invoice Created",
    "token":"test_6BaZCm7FXS"
}
Copy

EFFECTUER UN PAIEMENT
SANDBOX SOFTPAY
https://app.paydunya.com/sandbox-api/v1/softpay/checkout/make-payment
Copy


REQUEST HTTP POST

{
    "phone_phone": "97403627",
     "customer_email": "marnel.gnacadja@paydunya.com",
     "password": "Miliey@2121",
     "invoice_token": "test_6BaZCm7FXS"
}
Copy


 Note

phone_number : C'est le numéro de téléphone du compte de test.

customer_email : C'est l'email du compte de test.

password : C'est le mot de passe du compte de test.

invoice_token : C'est le token que vous avez obtenu plus haut lors de la génération du token de paiement



Expected Response

{
    "success": true,
    "message": "Paiement effectué avec succès."
}
Copy
Dans le cas où "success" est à "false" , s'il vous plaît, assurez-vous que :

la facture que vous essayez de régler n'est pas déjà à completed
vous avez fourni un token de paiement valide
Vous utilisez un compte de testhttps://developers.paydunya.com/doc/FR/introduction SoftPay
Vous serez obligé de rajouter chaque nouveau moyen de paiement dans votre application.
Les API peuvent avoir des dysfonctionnements si les partenaires de paiement font des modifications.

L’API SoftPay offre aux utilisateurs une meilleure expérience de paiement, totalement transparente pour le client sans interaction avec l’interface de PayDunya :

Le marchand a la possibilité de personnaliser son formulaire/page de paiement selon chaque moyen de paiement pour offrir une expérience de paiement propre à sa plateforme
Tout le paiement se déroulera sur le site du marchand
SoftPay s’intègre parfaitement au logiciel / site internet / App Mobile
International
CARTE BANCAIRE

Sénégal
Orange Money
Free Money
Expresso
Wave
Wizall
Djamo

Côte d'Ivoire
Orange Money
MTN
Moov
Wave
Djamo

Bénin
Moov
MTN

Burkina Faso
Orange Money
Moov

Togo
T-money
Moov Togo

Mali
Orange Money
Moov

Cameroun
MTN

Note :
En fonction du moyen de paiement utilisé par votre client, seul le pays associé à ce moyen de paiement sera rechargé. Ainsi, l’indisponibilité d’un moyen de paiement peut être liée à une restriction ou une limitation spécifique au pays concerné.

Si votre client essaie de payer via MTN BENIN, seul votre compte "BJ" sera rechargé.
Dans le cas où ce moyen de paiement n’apparaît à votre client dans les options de paiement, cela signifie probablement que votre compte "BJ" est temporairement restreint. Mais ceci n'affecte pas vos comptes dans les autres pays.es les sections en bleues pour mieux comprendre la documentation et les sections en orange signifiant l'alerte afin d'éviter des erreurs à commettre durant les intégrations et les procédures détaillées pour les intégration.


Génération de vos clés d'API
Les clés d'API sont vos références numériques auprès des systèmes de PayDunya. Nous les utilisons afin d'identifier votre compte et les applications que vous allez créer. Ces clés sont nécessaires pour toute intégration des APIs de paiements PayDunya. Voici chronologiquement la marche à suivre :

Vous devez d'abord avoir un compte PayDunya Business activé. Créez-en un si besoin y est.

Connectez-vous à votre compte et cliquez sur Intégrez notre API au niveau du menu à gauche.

Cliquez sur le bouton Configurer une nouvelle application et remplissez le formulaire.

Choisissez MODE TEST, JE VEUX FAIRE DES TESTS DE PAIEMENT. puis ACTIVER LE MODE DE PRODUCTION.


Intégration des APIs
Endpoints API LIVE
https://app.paydunya.com/api/v1/checkout-invoice/create
Copy


Requête POST HTTP

curl -H "Content-Type: application/json" \
-H "PAYDUNYA-MASTER-KEY: wQzk9ZwR-Qq9m-0hD0-zpud-je5coGC3FHKW" \
-H "PAYDUNYA-PRIVATE-KEY: live_private_rMIdJM3PLLhLjyArx9tF3VURAF5" \
-H "PAYDUNYA-TOKEN: IivOiOxGJuWhc5znlIiK" \
-X POST -d '{"invoice": {"total_amount": 5000, "description": "Chaussure VANS dernier modèle"},"store": {"name": "Magasin le Choco"}}' \
"https://app.paydunya.com/api/v1/checkout-invoice/create"
Copy
Réponse attendue

{
    "response_code":"00",
    "response_text":"https://app.paydunya.com/checkout/invoice/ERtyuILouhhRHICF0HboN",
    "description":"Checkout Invoice Created",
    "token":"ERtyuILouhhRHICF0HboN"
}
Copy
1 - Structure JSON complète des données à envoyer
Voici présentée ci-dessous, la structure complète de l'objet JSON de facturation PayDunya. La plupart des éléments sont optionnels, mais prenez l'habitude de tous les fournir car cela vous offrira beaucoup plus de flexibilité. Les nœuds JSON obligatoires pour la soumission d'une requête HTTP POST de paiement de facture vers nos Endpoints API sont : le nœud racine invoice et son noeud enfant total_amount ainsi que le nœud racine store et son noeud enfant name.


{
    "invoice": {
        "items": {
        },
        "taxes": {
        },
        "total_amount": 5000,
        "description": ""
    },
    "store": {
        "name": "Magasin le Choco",
        "tagline": "",
        "postal_address": "",
        "phone": "",
        "logo_url": "",
        "website_url": ""
    },
    "custom_data": {
    },
    "actions": {
        "callback_url": ""
    }
}
Copy
  Note

Lors de la création du checkout invoice, si logo_url est spécifié, il est utilisé pour afficher le logo sur la page de paiement. Sinon, c'est le logo par défaut du compte qui est affiché. En l'absence de tout logo configuré, une icône générique market est utilisée à la place.

2 - Ajout d'articles ou d'éléments sur la facture PayDunya
Référez-vous à la structure complète JSON afin de savoir de manière exacte où insérer la structure suivante. Les "items" sont utilisés pour afficher au client sur la page de paiement la liste des articles qu'il a commandé. PayDunya n'utilisera en aucun cas l'un des montants déclarés dans "items" pour facturer le client.


{
    "items": {
        "item_0": {
            "name": "Chaussures Croco",
            "quantity": 3,
            "unit_price": "10000",
            "total_price": "30000",
            "description": "Chaussures faites en peau de crocrodile authentique qui chasse la pauvreté"
        },
        "item_1": {
            "name": "Chemise Glacée",
            "quantity": 1,
            "unit_price": "5000",
            "total_price": "5000",
            "description": ""
        }
}
Copy
3 - Ajout de taxes (facultatif)
Si vous désirez afficher sur la facture PayDunya les taxes que vous appliquez (TVA, Frais de livraison...) vous pouvez le faire en utilisant le noeud JSON taxes comme illustré ci-dessous.


"taxes": {
    "tax_0": {
        "name": "TVA (18%)",
        "amount": 6300
    },
    "tax_1": {
        "name": "Livraison",
        "amount": 1000
    }
}
Copy
4 - Ajout de données personnalisées (facultatif)
Si vous avez besoin d'ajouter des données supplémentaires (par exemple pour un jeu concours, vous pouvez enregistrer des informations sur chaque gagnant) à des fins d'utilisation ultérieure, nous vous offrons la possibilité de sauvegarder ces données sur nos serveurs et de pouvoir les récupérer une fois le paiement réussi.

{info.fa-lightbulb-o}

Les données personnalisées ne sont affichées ni sur la page de paiement, ni sur les factures/reçus, ni sur les téléchargements et impressions. Elles sont uniquement récupérées à l'aide de notre action de callback confirm au niveau de l'API.

Exemple 1

"custom_data": {
    "categorie": "Jeu concours",
    "periode":  "Noël 2015",
    "numero_gagnant": 5,
    "prix" : "Bon de réduction de 50%"
}
Copy
Exemple 2

"custom_data": {
    "phone_brand": "Nokia",
    "IMEI": "72892821010728",
    "model": "Luna"
}
Copy
5 - Configuration de l'IPN (Instant Payment Notification)
Il se peut que pour des raisons x ou y, que la confirmation de paiement ne soit pas instantanée (par exemple le temps que le client tape son code secret sur son téléphone ou le temps de latence du réseau téléphonique), l'IPN vous permet de recevoir instantanément les informations de la transaction pour un paiement confirmé, annulé ou échoué.

L'IPN correspond à l'URL d'un fichier sur votre serveur sur lequel vous souhaitez recevoir les informations de la transaction de paiement, ces informations sont à traiter en backoffice. PayDunya utilise cette URL afin de vous envoyer instantanément, par requête POST, les informations relatives à la transaction de paiement.


"actions": {
    "callback_url": "http://www.magasin-le-choco.com/callback_url.php"
}
Copy
La validation réussie de la transaction de paiement retourne la structure ci-dessous contenant les informations sur le client, l'URL de sa facture PayDunya en version PDF et également un hash permettant de vérifier que les données reçues proviennent bien de nos serveurs. Par ailleurs il est capital de comprendre à titre d'information que les paiements annulés ou échoués gardent le même format de reponse sauf la valeur du statut qui change : pour les paiements échoués le statut devient failed et pour les paiements annulés devient cancelled.

Réponse attendue :

array (
  'data' => 
    array (
     'response_code' => '00',
     'response_text' => 'Transaction Found',
     'hash' => '8c6666a27fe5daeb76dae6abc7308a557dca5be1bda85dfe5d81fa330cdc0bc3c4b37765fe5d2cc36aa2ba0f9284226a80f5488d14740fa70769d6079a179406',
     'invoice' => 
        array (
         'token' => 'test_jkEdPY8SuG',
         'items' => 
            array (
             'item_0' => 
                array (
                  'name' => 'Chaussures Croco',
                  'quantity' => '3',
                  'unit_price' => '10000',
                  'total_price' => '30000',
                  'description' => 'Chaussures faites en peau de crocrodile authentique qui chasse la pauvreté',
               ),
             'item_1' => 
                array (
                 'name' => 'Chemise Glacée',
                 'quantity' => '1',
                 'unit_price' => '5000',
                 'total_price' => '5000',
                 'description' => '',
               ),
           ),
          'taxes' => 
            array (
              'tax_0' => 
                array (
                  'name' => 'TVA (18%)',
                  'amount' => '6300',
               ),
              'tax_1' => 
                array (
                'name' => 'Livraison',
                'amount' => '1000',
              ),
      ),
      'token': 'test_Jh2T8skw1j',
      'total_amount' => '42300',
      'description' => 'Paiement de 42300 FCFA pour article(s) achetés sur Magasin le Choco',
      ),
      'custom_data' => 
        array (
          'categorie' => 'Jeu concours',
          'periode' => 'Noël 2015',
          'numero_gagnant' => '5',
          'prix' => 'Bon de réduction de 50%',
        ),
      'actions' => 
        array (
          'cancel_url' => 'http://magasin-le-choco.com/cancel_url.aspx',
          'callback_url' => 'http://magasin-le-choco.com/callback_url.aspx',
          'return_url' => 'http://magasin-le-choco.com/return_url.aspx',
        ),
      'mode' => 'test',
      'status' => 'completed',
      'customer' => 
        array (
         'name' => 'Alioune Faye',
         'phone' => '774563209',
         'email' => 'aliounefaye@gmail.com',
        ),
      'receipt_url' => 'https://paydunya.com/sandbox-checkout/receipt/pdf/test_jkEdPY8SuG.pdf',
    ),
  )  
Copy
Le hash renvoyé par PayDunya est le hash de votre MasterKey (clé principale). Ce hash vous permettra de vous assurer que les données que vous avez reçues proviennent de nos serveurs. L'algorithme utilisé pour obtenir le hash est du SHA-512. Dans la réponse attendue un message d'échec est renseigné dans le noeud fail_reason seulement pour les transactions par carte bancaires échouées ou annulées.


Paiement par CARTE BANCAIRE
  Alerte

L'API SOFTPAY pour les paiements par carte bancaire n'est disponible que pour les entreprises certifiés PCI-DSS. L'activation se fait sur demande.

Endpoints API CARTE BANCAIRE
https://app.paydunya.com/api/v1/softpay/card
Copy


Requête POST HTTP
{
  "full_name": "John Doe",
  "email": "test@paydunya.com",
  "card_number": "1234567890123456",
  "card_cvv": "123",
  "card_expired_date_year": "25",
  "card_expired_date_month": "11",
  "token": "T3JgbeD3xHXoWtmqOktm"
}
Copy


Réponse attendue
{
  "success": true,
  "message": "Le paiement a été effectué avec succès.",
  "fees"   : 100, // Si c'est le payeur qui supporte les frais.
  "currency" : "XOF" // Si c'est le payeur qui supporte les frais.
}
Copy


Réponse attendue CAS CARTE 3DS
{
  "success": true,
  "message": "Rediriger vers cette URL pour completer le paiement.",
  "url": "https://paydunya.com/card_3ds_redirect?key=eyJ0aHJlZURTU2VydmVyVHJhbnNJRCI6IjYwYmRjNmU0LWRjNjMtNDIxNy05OTU3LTVjZDc0M5zSUQiOiJmZjkxMzc1Mi0zOGRmLTRjZTYtYjM5Zi00MTg4MTE0OTg1ZWQiLCJjaGFsbGVuZ2VXaW5kb3dTaXplIjoiMDUiLCJtZXNzYWdlVHlwZSI6IkNSZXEiLCJtZXNzYWdlVmVyc2lvbiI6IjIuMS4wIn0&url=https://authentication.cardinalcommerce.com/ThreeDSecure/V2_1_0/CReq",
  "fees"   : 100, // Si c'est le payeur qui supporte les frais.
  "currency" : "XOF" // Si c'est le payeur qui supporte les frais.
}
Copy


Réponse attendue cas d'échec
{
  "success": false,
    "message": "Transaction annulée ou Refus de paiement en lien avec votre établissement bancaire.",
    "errors": {
        "message": "Transaction annulée ou Refus de paiement en lien avec votre établissement bancaire.",
        "description": "Transaction annulée ou Refus de paiement en lien avec votre établissement bancaire."
  }
}
Copy

Paiement par ORANGE MONEY SENEGAL
Découvrez notre toute nouvelle mise à jour de l'API Orange Money Sénégal ! Désormais, offrez à vos clients la possibilité de payer facilement par QR CODE. Pour une intégration simple et rapide, suivez la documentation ci-dessous.

Endpoints API ORANGE MONEY SENEGAL QR CODE
https://app.paydunya.com/api/v1/softpay/new-orange-money-senegal
Copy


Requête POST HTTP

{
  "customer_name": "John Doe",
  "customer_email": "test@gmail.com",
  "phone_number": "778676477",
  "invoice_token": "GS46gkCAnRv3WfRwFdJU",
}
Copy
"customer_name": C'est le nom du payeur
"customer_email": C'est l'email du payeur
"phone_number": C'est le numéro du payeur
"invoice_token": C'est le TOKEN de paiement généré plus haut


Réponse attendue

{
  "success": true,
  "message": "Rediriger vers cette URL pour completer le paiement.",
  "url": "https://app.paydunya.com/recharge-orange-sn?data%5Bqrcode%5D=iVBORw0KGgoAAAANSUhEUgAAAMgAAADICAAAAACIM%2FFCAAAAAklEQVR4nGKkkSsAAAHxSURBVO3Q23EbQQwEQOaftB3AaaCBZJZX2sbX1RKPab7%2B%2FJJ6%2Fe8A%2F6pATiuQ0wrktAI5rUBOq18KedX1wable%2Fr1ixlAQEAuhqSjz555eers9y96QEBAroekkOm7Pz0DtxlAQEBAtkvml0UYEBAQkDdD5p5mKv0KAgICsoWk6gOkMCne1zKAgICA9Kff973lg4CA3AnZVgow9z975qkuyvemQUDi6u9Ng7wZ8jyUjqbTaUOzuemPZBAQkCshffj%2BXOpsws95QEBAQJoTzdEU%2BBmj%2F%2F5kMwgIyJWQ9XiBbTjz9fQCAgICksbnc%2F3svDNFrTggICBXQraomdbsmQmLAgEBuRgyr03B0lTzMt997v9gAwgIyMWQOXDf03w3L%2FMsCAjIzZAUrKkmRv%2BSCgQEBGQeSYH%2FOHzJy%2BEwQEBKQZScAUI22r4oUNICAgINvaBp4JaQoEBARkhqTxPuTzPf069%2Fd8EBCQmyHbmk%2FP%2Fenl2Z9ugYCAgKRgackcO%2FXMe%2Bb98SIICMjFkG2wbbyv7fwkGwgIyPWQtOS5MB2a3%2BfA%2FSwICAhID9l%2BJ%2BD8PdNAQEBAekgfL%2FXMtcgAAgJyPWRePh%2Faxmj%2BqE9%2BBQEBuRjS1BxpjpribckgICAgP7hATiuQ0wrktAI5rUBOK5DT6i8Qn6uozO88rQAAAABJRU5ErkJggg%3D%3D&data%5Btoken%5D=2da19f97721d74b725cd0bfec625637f52a4fe8180069fdcea8e0658b319a102",
  "other_url": {
      "om_url": "https://orangemoneysn.page.link/BqPM68VcrMniRxE",
      "maxit_url": "https://sugu.orange-sonatel.com/mp/dpBtHptARK6Br_t5k3"
    },
  "fees"   : 100, // Si c'est le payeur qui supporte les frais.
  "currency"   : "XOF" // Si c'est le payeur qui supporte les frais.
}
Copy
"url": C'est pour rediriger le payeur vers la page de paiement avec le QR CODE
"om_url": C'est pour rediriger le payeur vers son application Orange Money s'il utilise un téléphone mobile
"maxit_url": C'est pour rediriger le payeur vers son application Maxit s'il utilise un téléphone mobile



Paiement par FREE MONEY SENEGAL
Endpoints API FREE MONEY SENEGAL
https://app.paydunya.com/api/v1/softpay/free-money-senegal
Copy


Requête POST HTTP

{
  "customer_name": "John Doe",
  "customer_email": "test@gmail.com",
  "phone_number": "768690999",
  "payment_token": "GS46gkCAnRv3WfRwFdJU"
}
Copy


Réponse attendue

{
  "success": true,
  "message": "Opération réussie, Veuillez tapez #150# pour finaliser votre paiement.",
  "fees"   : 100, // Si c'est le payeur qui supporte les frais.
  "currency" : "XOF" // Si c'est le payeur qui supporte les frais.
  "data": {
    "status": "PENDING",
    "amount": 200,
    "currency": "XOF",
    "customermsisdn": 768690999,
    "transactionid": "MP210921.1230.B04577",
    "externaltransactionid": "FM076_93108370"
  }
}
Copy

Paiement par EXPRESSO SENEGAL
Endpoints API EXPRESSO
https://app.paydunya.com/api/v1/softpay/expresso-senegal
Copy


Requête POST HTTP

{
  "expresso_sn_fullName": "John Doe",
  "expresso_sn_email": "test@gmail.com",
  "expresso_sn_phone": "705189525",
  "payment_token": "GS46gkCAnRv3WfRwFdJU"
}
Copy


Réponse attendue

{
  "success" : true,
  "message" : "Votre paiement est en cours de traitement. Merci de valider le paiement après reception de sms pour le compléter.",
  "fees"   : 100, // Si c'est le payeur qui supporte les frais.
  "currency": "XOF" // Si c'est le payeur qui supporte les frais.
}
Copy

Paiement par WAVE SENEGAL
Endpoints API WAVE
https://app.paydunya.com/api/v1/softpay/wave-senegal
Copy


Requête POST HTTP

{
  "wave_senegal_fullName": "John Doe",
  "wave_senegal_email": "test@gmail.com",
  "wave_senegal_phone": "777777777",
  "wave_senegal_payment_token": "OnW1IkMIQDTiJnQ9S3Ix"
}
Copy


Réponse attendue


{
    "success": true,
    "message": "Rediriger vers cette URL pour completer le paiement.",
    "url": "https://pay.wave.com/c/cos-1cj669hbr1350?a=200&c=XOF&m=JOE",
    "fees"   : 100, // Si c'est le payeur qui supporte les frais.
    "currency": "XOF" // Si c'est le payeur qui supporte les frais.
}
Copy

Paiement par WIZALL SENEGAL
Endpoints API WIZALL
https://app.paydunya.com/api/v1/softpay/wizall-money-senegal
Copy


Requête POST HTTP
{
  "customer_name": "John Doe",
  "customer_email": "test@gmail.com",
  "phone_number": "777777777",
  "invoice_token": "RAV6KK9Ncfy2a6vb3KDT"
}
Copy


Réponse attendue
{
    "success": true,
    "message": "Requête de paiement effectuée!",
    "data": {
        "Operation": "MerchantGetMoney",
        "TransactionID": "286513913",
        "details": {
            "message": "MerchantGetMoney Successful",
            "service": "merchant-get-money",
            "cid": "489eca906856e440e193ab19"
        }
    },
    "fees"   : 100, // Si c'est le payeur qui supporte les frais.
    "currency": "XOF" // Si c'est le payeur qui supporte les frais.
}
Copy


Endpoints API WIZALL CONFIRM
https://app.paydunya.com/api/v1/softpay/wizall-money-senegal/confirm
Copy


Requête POST HTTP
{
  "authorization_code": "461050",
  "phone_number": "777777777",
  "transaction_id": "286513913"
}
Copy


Réponse attendue
{
  "success": true,
  "message": "Paiement réussi",
  "return_url": "https://www.paydunya.com/successful-payment",
  "token": "oeKyZGwexXkBk4uYyRoJ"
}
Copy

Paiement par ORANGE MONEY COTE D'IVOIRE
Après avoir généré le token, vous devez demander à l'utilisateur final de générer un code de paiement Orange Money en suivant le code USSD suivant:

#144*82# + option 2 pour obtenir le code de paiement.
Copy


Endpoints API ORANGE MONEY COTE D'IVOIRE
https://app.paydunya.com/api/v1/softpay/orange-money-ci
Copy


Requête POST HTTP
{
  "orange_money_ci_customer_fullname": "John Doe",
  "orange_money_ci_email": "test@gmail.com",
  "orange_money_ci_phone_number": "0777568646",
  "orange_money_ci_otp": "8562",
  "payment_token": "ljUZxD5T3RRxhpoOl66b"
}
Copy


Réponse attendue
{
    "success": true,
    "message": "Paiement effectué avec succès."
    "fees"   : 100, // Si c'est le payeur qui supporte les frais.
    "currency": "XOF" // Si c'est le payeur qui supporte les frais.
}
Copy

Paiement par MTN MONEY COTE D'IVOIRE
Endpoints API MTN MONEY COTE D'IVOIRE
https://app.paydunya.com/api/v1/softpay/mtn-ci
Copy


Requête POST HTTP
{
  "mtn_ci_customer_fullname": "John Doe",
  "mtn_ci_email": "test@gmail.com",
  "mtn_ci_phone_number": "664142312",
  "mtn_ci_wallet_provider": "MTNCI",
  "payment_token": "OnW1IkMIQDTiJnQ9S3Ix"
}
Copy


Réponse attendue
{
  "success": true,
  "message": "success message",
  "fees"   : 100, // Si c'est le payeur qui supporte les frais.
  "currency": "XOF" // Si c'est le payeur qui supporte les frais.
}
Copy

Paiement par MOOV CÔTE D'IVOIRE
API MOOV CÔTE D'IVOIRE
https://app.paydunya.com/api/v1/softpay/moov-ci
Copy


Requête POST HTTP
{
    "moov_ci_customer_fullname": "Camille",
    "moov_ci_email": "camillemilly7@gmail.com",
    "moov_ci_phone_number": "0153401679",
    "payment_token": "dzSNGqLCohvsFq9KlCmN"
}
Copy


Réponse attendue
{
    "success": true,
    "message": "Votre transaction a été validée avec succès.",
    "fees"   : 100, // Si c'est le payeur qui supporte les frais.
    "currency"   : "XOF" // Si c'est le payeur qui supporte les frais.
}
Copy
 Note

Lorsque vous lancez un paiement par MOOV CI , un popup s'ouvre automatiquement sur votre téléphone avec un champs de saisie de votre code secret pour validation du paiement.

Si le delai de la validation dépasse 30 secondes , L'API renvoie la réponse ci-dessous :



Réponse attendue
{
    "success": false,
    "message": "Vous avez dépassé le délai de validation de la transaction."
}
Copy

Paiement par WAVE CÔTE D'IVOIRE
API WAVE CÔTE D'IVOIRE
https://app.paydunya.com/api/v1/softpay/wave-ci
Copy


Requête POST HTTP
{
    "wave_ci_fullName": "Camille",
    "wave_ci_email": "test@gmail.com",
    "wave_ci_phone": "774599837",
    "wave_ci_payment_token" : "eVnEmduF6DmaXKxsJn4r"
}
Copy


Réponse attendue

{
    "success": true,
    "message": "Rediriger vers cette URL pour completer le paiement.",
    "url": "https://pay.wave.com/c/cos-1cj669hbr1350?a=200&c=XOF&m=JOE",
    "fees"   : 100, // Si c'est le payeur qui supporte les frais.
    "currency": "XOF" // Si c'est le payeur qui supporte les frais.
}
Copy

Paiement par ORANGE MONEY BURKINA FASO
Endpoints API ORANGE MONEY BURKINA FASO
https://app.paydunya.com/api/v1/softpay/orange-money-burkina
Copy


Requête POST HTTP
{
  "name_bf": "John Doe",
  "email_bf": "test@gmail.com",
  "phone_bf": "76950976",
  "otp_code": "89525",
  "payment_token": "lLTs7h0tor82tchzvSec"
}
Copy


Réponse attendue
{
  "success": true,
  "message": "success message",
  "fees"   : 100, // Si c'est le payeur qui supporte les frais.
  "currency": "XOF" // Si c'est le payeur qui supporte les frais.
}
Copy

Paiement par MOOV BURKINA FASO
Endpoints API MOOV BURKINA FASO
https://app.paydunya.com/api/v1/softpay/moov-burkina
Copy


Requête POST HTTP
{
  "moov_burkina_faso_fullName": "John Doe",
  "moov_burkina_faso_email": "test@gmail.com",
  "moov_burkina_faso_phone_number": "51765664",
  "moov_burkina_faso_payment_token": "lLTs7h0tor82tchzvSec"
}
Copy


Réponse attendue
{
  "success": true,
  "message": "Veuillez compléter le paiement en composant le *555*6#.",
  "fees"   : 100, // Si c'est le payeur qui supporte les frais.
  "currency": "XOF" // Si c'est le payeur qui supporte les frais.
}
Copy

Paiement par MOOV BENIN
Endpoints API MOOV BENIN
https://app.paydunya.com/api/v1/softpay/moov-benin
Copy


Requête POST HTTP
{
  "moov_benin_customer_fullname": "Camille",
  "moov_benin_email": "camillemilly7@gmail.com",
  "moov_benin_phone_number": "0140253725",
  "payment_token": "lLTs7h0tor82tchzvSec"
}
Copy


Réponse attendue
{
  "success": true,
  "message": "Success message",
  "fees"   : 100, // Si c'est le payeur qui supporte les frais.
  "currency": "XOF" // Si c'est le payeur qui supporte les frais.
}
Copy

Paiement par MTN BENIN
Endpoints API MTN BENIN
https://app.paydunya.com/api/v1/softpay/mtn-benin
Copy


Requête POST HTTP
{
  "mtn_benin_customer_fullname": "Camille",
  "mtn_benin_email": "camillemilly7@gmail.com",
  "mtn_benin_phone_number": "66414231",
  "mtn_benin_wallet_provider": "MTNBENIN",
  "payment_token": "lLTs7h0tor82tchzvSec"
}
Copy


Réponse attendue
{
  "success": true,
  "message": "Votre paiement est en cours de traitement. Merci de valider le paiement après reception de sms pour le compléter",
  "fees"   : 100, // Si c'est le payeur qui supporte les frais.
  "currency": "XOF" // Si c'est le payeur qui supporte les frais.
}
Copy

Paiement par T-MONEY TOGO
Endpoints API T-Money
https://app.paydunya.com/api/v1/softpay/t-money-togo
Copy


Requête POST HTTP
{
  "name_t_money": "Camille",
  "email_t_money": "exemple@paydunya.com",
  "phone_t_money": "70707070","
  "payment_token": "lLTs7h0tor82tchzvSec"
}
Copy


Réponse attendue
{
  "success": true,
  "message": "Votre paiement est en cours de traitement. Merci de valider le paiement après reception de sms pour le compléter.",
  "fees"   : 100, // Si c'est le payeur qui supporte les frais.
  "currency": "XOF" // Si c'est le payeur qui supporte les frais.
}
Copy

Paiement par MOOV TOGO
Endpoints API Moov Togo
https://app.paydunya.com/api/v1/softpay/moov-togo
Copy


Requête POST HTTP
{
  "moov_togo_customer_fullname": "TEST",
  "moov_togo_email": "test@paydunya.com",
  "moov_togo_customer_address": "DAKAR",
  "moov_togo_phone_number": "12345678",
  "payment_token": "ERtyuIrLouhhRHICF0HboN"
}
Copy


Réponse attendue
{
  "success": true,
  "message": "Transaction effectuée avec succès",
  "fees"   : 100, // Si c'est le payeur qui supporte les frais.
  "currency"   : "XOF" // Si c'est le payeur qui supporte les frais.
}
Copy

Paiement par ORANGE MONEY MALI
Endpoints API ORANGE MONEY MALI
https://app.paydunya.com/api/v1/softpay/orange-money-mali
Copy


Requête POST HTTP
{
    "orange_money_mali_customer_fullname": "Camille",
    "orange_money_mali_email": "camillemilly7@gmail.com",
    "orange_money_mali_phone_number": "90239415",
    "orange_money_mali_customer_address" : "Bamako",
    "payment_token": "9MHW084mlDTpExGW8OY4"
}
Copy


Réponse attendue
{
    "success": true,
    "message": "Paiement enregistré, en attente de confirmation du client"
}
Copy

Paiement par MOOV MALI
Endpoints API MOOV MALI
https://app.paydunya.com/api/v1/softpay/moov-mali
Copy


Requête POST HTTP
{
  "moov_ml_customer_fullname": "John Doe",
  "moov_ml_email": "test@paydunya.com",
  "moov_ml_phone_number": "90239415",
  "moov_ml_customer_address" : "Bamako",
  "payment_token": "6KIFXkAiAU70uuam5Dix"
}
Copy


Réponse attendue
{
    "success": true,
    "message": "Merci de finaliser le paiement sur votre téléphone.",
    "fees"   : 100, // Si c'est le payeur qui supporte les frais.
    "currency"   : "XOF" // Si c'est le payeur qui supporte les frais.
}
Copy

Paiement par MTN CAMEROUN
Endpoints API MTN CAMEROUN
https://app.paydunya.com/api/v1/softpay/mtn-cameroun
Copy


Requête POST HTTP
{
  "mtn_cameroun_customer_fullname": "John Doe",
  "mtn_cameroun_email": "test@paydunya.com",
  "mtn_cameroun_phone_number": "670000000",
  "mtn_cameroun_wallet_provider": "MTNCAMEROUN",
  "payment_token": "6KIFXkAiAU70uuam5Dsix"
}
Copy


Réponse attendue
{
    "success": true,
    "message": "Votre paiement est en cours de traitement. Merci de valider le paiement après reception de sms pour le compléter.",
    "fees"   : 100, // Si c'est le payeur qui supporte les frais.
    "currency"   : "XAF" // Si c'est le payeur qui supporte les frais.
}
Copy

Paiement par DJAMO SENEGAL
Endpoints API DJAMO
https://app.paydunya.com/api/v1/softpay/djamo
Copy
Requête POST HTTP
{
    "djamo_fullName": "Camille",
    "djamo_email": "camillemilly7@gmail.com",
    "djamo_phone": "778676477",
    "code_country": "sn",
    "djamo_payment_token": "9MHW084mlDTpExGW8OY4"
}
Copy


Réponse attendue
{
    "success": true,
    "url": "https://p.djamo.com/payment-link/?type=payment_confirmation&chargeId=363a0bea-7859-4cd7-a489-6d74d00c8469",
    "message": "Rediriger vers cette URL pour completer le paiement."
}
Copy

Paiement par DJAMO CÔTE D'IVOIRE
Endpoints API DJAMO
https://app.paydunya.com/api/v1/softpay/djamo
Copy
Requête POST HTTP
{
    "djamo_fullName": "Camille",
    "djamo_email": "camillemilly7@gmail.com",
    "djamo_phone": "0777568646",
    "code_country": "ci",
    "djamo_payment_token": "9MHW084mlDTpExGW8OY4"
}
Copy


Réponse attendue
{
    "success": true,
    "url": "https://p.djamo.com/payment-link/?type=payment_confirmation&chargeId=363a0bea-7859-4cd7-a489-6d74d00c8469",
    "message": "Rediriger vers cette URL pour completer le paiement."
}
Copy

Paiement par PAYDUNYA
Endpoints API PAYDUNYA
https://app.paydunya.com/api/v1/softpay/paydunya
Copy


Requête POST HTTP
{
  "customer_name": "John Doe",
  "customer_email": "exemple@paydunya.com",
  "phone_phone": "77777777",
  "password": "12345678",
  "invoice_token": "lLTs7h0tor82tchzvSec"
}
Copy


Réponse attendue
{
  "success": true,
  "message": "Success message",
  "fees"   : 100, // Si c'est le payeur qui supporte les frais.
  "currency": "XOF" // Si c'est le payeur qui supporte les frais.
}SoftPay
Vous serez obligé de rajouter chaque nouveau moyen de paiement dans votre application.
Les API peuvent avoir des dysfonctionnements si les partenaires de paiement font des modifications.

L’API SoftPay offre aux utilisateurs une meilleure expérience de paiement, totalement transparente pour le client sans interaction avec l’interface de PayDunya :

Le marchand a la possibilité de personnaliser son formulaire/page de paiement selon chaque moyen de paiement pour offrir une expérience de paiement propre à sa plateforme
Tout le paiement se déroulera sur le site du marchand
SoftPay s’intègre parfaitement au logiciel / site internet / App Mobile
International
CARTE BANCAIRE

Sénégal
Orange Money
Free Money
Expresso
Wave
Wizall
Djamo

Côte d'Ivoire
Orange Money
MTN
Moov
Wave
Djamo

Bénin
Moov
MTN

Burkina Faso
Orange Money
Moov

Togo
T-money
Moov Togo

Mali
Orange Money
Moov

Cameroun
MTN

Note :
En fonction du moyen de paiement utilisé par votre client, seul le pays associé à ce moyen de paiement sera rechargé. Ainsi, l’indisponibilité d’un moyen de paiement peut être liée à une restriction ou une limitation spécifique au pays concerné.

Si votre client essaie de payer via MTN BENIN, seul votre compte "BJ" sera rechargé.
Dans le cas où ce moyen de paiement n’apparaît à votre client dans les options de paiement, cela signifie probablement que votre compte "BJ" est temporairement restreint. Mais ceci n'affecte pas vos comptes dans les autres pays.
