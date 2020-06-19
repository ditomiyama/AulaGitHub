<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="theme-color" content="#000000" />
    <title>Ecori Order Tracker</title>
    <link rel="stylesheet" href="style.css">
    <script src="https://kit.fontawesome.com/e5ddec6dcb.js" crossorigin="anonymous"></script>
  </head>
  <body>
    <div id="root">
        <div class="register-container">
            <div class="content">

                <form>
                    <img src='ecorilogo.png'>
                    <p>Consulte o Status do seu pedido</p>
                    <div id='form-content'>
                    <label for='cPed' >Número Pedido </label>
                    <input placeholder="Número Pedido" value='' id='cPed' />
                    <label for='cDoc'>Número Documento </label>
                    <input placeholder="Número Documento" value='' id='cDoc' />
                    </div>
                    <button class="button" type='button' id='enviar'>Consultar</button>
                </form>      
                <p class='versao'>Atualizado: Code - 08/05/2020 2:00am, Base - 06/05/2020 4:51am</p>
                
              </div>

        <div class="content" id='order'>
          <h2>Informações do pedido</h2>  
          <section>
            <span id='_pedido'></span>
            <span id='_cliente'></span>
            <span id='_emissao'></span>            
            <span id='_frete'></span>
            <span id='_dtEntrega'></span>
            <br>
            <ul id='status'>
            <li><span id='passo0' class='status'></span></li>
            <li><span id='passo1' class='status'></span></li>
            <li><span id='passo2' class='status'></span></li>
            <li><span id='passo3' class='status'></span></li>
            <li><span id='passo4' class='status'></span></li>
            <li><span id='passo5' class='status'></span></li>
            <ul>
          </section>
          <h2>Itens do pedido</h2>  
          <section id='tabela'>            
            <div><b>Desc. Produtos</b></div><div><b>Qtd</b></div>
          </section>
        </div>

        </div>
    </div>
</body>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script>

//const axios = require('axios');
document.getElementById("enviar").addEventListener('click',getPed)
function getPed(e){
  document.getElementById("order").style.display = "none"
    e.preventDefault()

    const cPed = document.getElementById('cPed').value
    const cDoc = document.getElementById('cDoc').value
    
    if(cPed == '' || cDoc == ''){
    alert('Os campos precisam estar preenchidos!')
    return false
    }
    
    axios.get(`ped.php?cPed=${cPed}&cDoc=${cDoc}`)
    .then(function (response) {
      const { data } = response
      const objJson = data
      console.log(objJson)  
      if (typeof objJson.pedido === 'undefined') {
        const items = document.querySelectorAll("span")
        items.forEach((userItem) => {
          userItem.innerHTML = '';
        });
        alert('Nenhum pedido encontrado')
        return false
      }
      
        document.getElementById("order").style.display = "flex"    
        document.getElementById("_pedido").innerHTML = "<b>Pedido: </b> " + objJson.pedido
        document.getElementById("_cliente").innerHTML = "<b>Cliente: </b> " + objJson.razao_social
        document.getElementById("_emissao").innerHTML = "<b>Data Emissão:</b> " + objJson.data_emissao
        document.getElementById("_frete").innerHTML = "<b>Transporte:</b> " + objJson.tipo_frete
        const data_entrega = (objJson.data_prev_entrega == 'null') ? objJson.data_prev_entrega : 'Sem Data'
        document.getElementById("_dtEntrega").innerHTML = "<b>Previsão de Entrega:</b> " + data_entrega


        axios.get(`zero.php?cPed=${cPed}&cDoc=${cDoc}`)
        .then(function (response) {
          const { data } = response
              const objJson = data
              if (typeof objJson.status !== 'undefined') {
                console.log(objJson.status)
                document.getElementById("passo0").innerHTML = objJson.status
              }
        })
        .catch(function (error) {

          console.log(error);
        })
        .then(function (response) {
          console.log('finalizado zero')
        });


        /////////////////////////////////////
        axios.get(`um.php?cPed=${cPed}&cDoc=${cDoc}`)
        .then(function (response) {
          const { data } = response
              const objJson = data
              if (typeof objJson.status !== 'undefined') {
                console.log(objJson.status)
                document.getElementById("passo1").innerHTML = objJson.status
              }
        })
        .catch(function (error) {

          console.log(error);
        })
        .then(function (response) {
          console.log('finalizado 1')
        });
  


          //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
          axios.get(`dois.php?cPed=${cPed}&cDoc=${cDoc}`)
              .then(function (response) {
              const { data } = response
                  const objJson = data
                  if (typeof objJson.status !== 'undefined') {
                    document.getElementById("passo2").innerHTML = objJson.status
                  }
            })
            .catch(function (error) {
              console.log(error);
            })
            .then(function (response) {
              console.log('finalizado 2')
            });

          //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
          axios.get(`tres.php?cPed=${cPed}&cDoc=${cDoc}`)
              .then(function (response) {
              const { data } = response
                  const objJson = data
                  if (typeof objJson.status !== 'undefined') {
                    document.getElementById("passo3").innerHTML = objJson.status
                  }
            })
            .catch(function (error) {
              console.log(error);
            })
            .then(function (response) {
              console.log('finalizado 3')
            });

          //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

          axios.get(`quatro.php?cPed=${cPed}&cDoc=${cDoc}`)
              .then(function (response) {
              // handle success
              const { data } = response
              //console.log(response)
                  const objJson = data
                  if (typeof objJson.status !== 'undefined') {
                    document.getElementById("passo4").innerHTML = objJson.status
                  }
            })
            .catch(function (error) {
              console.log(error);
            })
            .then(function (response) {
              console.log('finalizado 4')
            });

          //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
          axios.get(`cinco.php?cPed=${cPed}&cDoc=${cDoc}`)
              .then(function (response) {
              // handle success
              const { data } = response
              //console.log(response)
                  const objJson = data
                  if (typeof objJson.status !== 'undefined') {
                    //document.getElementById("_status5").innerHTML += "<li>" +  objJson.status + " - " + objJson.nfiscal + "</li>"
                  }
            })
            .catch(function (error) {
              console.log(error);
            })
            .then(function (response) {
              console.log('finalizado 5')
            });

            
            axios.get(`pedItem.php?cPed=${cPed}&cDoc=${cDoc}`)
              .then(function (response) {
              const { data } = response
                  const objJson = data
                  console.log(objJson)
                  console.log(objJson.length)
                  let aux
                  document.getElementById('tabela').innerHTML = ""
                  for(aux=0; aux < objJson.length; aux++){
                    document.getElementById('tabela').innerHTML += "<div>" + objJson[aux]['produto'] + "</div><div>" + objJson[aux]['quantidade'] + "</div>"
                  }
            })
            .catch(function (error) {
              console.log(error);
            })
            .then(function (response) {
              console.log('finalizado items')
            });

    }) // final do ped
    .catch(function (error) {
      console.log(error);
    })
    .then(function (response) {
      console.log('finalizado dados do pedido')
    });
}

</script>
</html>