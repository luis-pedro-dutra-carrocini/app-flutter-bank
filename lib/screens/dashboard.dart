import 'package:flutter/material.dart';
import 'contatos/lista_contatos.dart';
import 'transferencia/lista.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dasboard")),

      body: SingleChildScrollView(
        child: Container(
          // fundo suave e padding
          color: Colors.grey.shade300,
          padding: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(8.0),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // logotipo com bordas arredondadas
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        "images/bytebank_logo.png",
                        height: 200,
                      ),
                    ),
                  ],
                ),

                // Espaçamento entre logo e botão
                const SizedBox(height: 32.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                  children: [
                    // Primeiro card: Contatos
                    _FeatureItem(
                      nome: 'Contatos',
                      icone: Icons.people,
                      onClick: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ListaContatos(),
                          ),
                        );
                      },
                    ),

                    // Segundo card: Transferências
                    _FeatureItem(
                      nome: 'Transferências',
                      icone: Icons.monetization_on,
                      onClick: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ListaTransferencias(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String nome;
  final IconData icone;
  final void Function() onClick;

  const _FeatureItem({
    required this.nome,
    required this.icone,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 61, 139, 65),
      borderRadius: BorderRadius.circular(6),
      elevation: 2,

      // Usa InkWell para efeito visual de toque
      child: InkWell(
        onTap: onClick,
        borderRadius: BorderRadius.circular(6),

        child: Container(
          height: 130,
          width: 130,
          padding: const EdgeInsets.all(8),

          // Coluna centralizada com ícone e texto
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icone, color: Colors.white, size: 32),

              const SizedBox(height: 8),

              // Ajuste principal: uso de FittedBox para adaptar o texto ao espaço disponível
              FittedBox(
                fit: BoxFit.scaleDown, //reduz o texto apenas quando necessário
                child: Text(
                  nome,
                  textAlign:
                      TextAlign.center, // centraliza o texto em caso de quebra
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize:
                        16, // tamanho base, mas será reduzido automaticamente se necessário
                    //deixa o texto mais legível em telas pequenas.
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
