import 'package:flutter/material.dart';
import '../../components/editor.dart';
import '../../models/transferencia.dart';
import '../../database/app_database.dart';

class FormularioTransferencia extends StatefulWidget {
  final int? numeroConta;

  const FormularioTransferencia({
    super.key,
    this.numeroConta,
  }); // construtor com parâmetro

  @override
  State<StatefulWidget> createState() {
    return FormularioTransferenciaState();
  }
}

class FormularioTransferenciaState extends State<FormularioTransferencia> {
  final TextEditingController _controladorCampoNumeroConta =
      TextEditingController();
  final TextEditingController _controladorCampoValor = TextEditingController();

  static const _tituloAppBar = 'Criando Transferência';
  static const _rotuloCampoValor = 'Valor';
  static const _dicaCampoValor = 'Ex: 12.55';

  static const _rotuloCampoNumeroConta = 'Número Conta';
  static const _dicaCampoNumeroConta = 'Ex: 00000000';
  static const _textBotaoConfirmar = 'Confirmar';

  @override
  void initState() {
    super.initState();

    // se vier um número de conta do contato, já preenche o campo automaticamente
    if (widget.numeroConta != null) {
      _controladorCampoNumeroConta.text = widget.numeroConta.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_tituloAppBar)),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Editor(
              controlador: _controladorCampoNumeroConta,
              rotulo: _rotuloCampoNumeroConta,
              dica: _dicaCampoNumeroConta,
              icone: Icons.numbers,
              tipoTeclado: TextInputType.number,
            ),

            Editor(
              controlador: _controladorCampoValor,
              rotulo: _rotuloCampoValor,
              dica: _dicaCampoValor,
              icone: Icons.monetization_on,
              tipoTeclado: TextInputType.numberWithOptions(decimal: true),
            ),

            ElevatedButton(
              child: Text(_textBotaoConfirmar),
              onPressed: () {
                debugPrint("Clicou no Confirmar!");
                _criaTransferencia(
                  context,
                  _controladorCampoNumeroConta,
                  _controladorCampoValor,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Função que cria uma nova transferência a partir dos campos de texto do formulário
// Recebe o BuildContext (para navegar de volta) e os controladores de texto
void _criaTransferencia(
  BuildContext context,
  TextEditingController controladorCampoNumeroConta,
  TextEditingController controladorCampoValor,
) async {
  // Converte o texto do campo "Número da Conta" em int, retorna null se não for válido
  final int? numeroConta = int.tryParse(controladorCampoNumeroConta.text);

  // Converte o texto do campo "Valor" em double, retorna null se não for válido
  final double? valor = double.tryParse(controladorCampoValor.text.replaceAll(',', '.'));

  // Só prossegue se ambos os valores forem válidos
  if (numeroConta != null && valor != null) {
    // Cria um objeto Transferencia com os dados fornecidos
    final transferenciaCriada = Transferencia(valor, numeroConta);

    try {
      // 'await' pausa a execução até que a função 'salvarTransferencia'
      // termine de gravar a transferência no banco de dados
      await salvarTransferencia(transferenciaCriada);

      // Verifica se o contexto ainda está montado (isto é, se o widget ainda está na árvore)
      // Isso evita erros caso o usuário saia da tela antes da operação terminar
      if (context.mounted) {
        // Exibe uma mensagem temporária de sucesso na parte inferior da tela
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transferência salva com sucesso!')),
        );

        // Fecha a tela atual e retorna para a anterior (ex: a lista de transferências)
        Navigator.pop(context);
      }

      // Caso ocorra algum erro durante a tentativa de salvar a transferência
      // (por exemplo, falha no banco de dados), o código do 'catch' é executado
    } catch (e) {
      // Exibe uma mensagem de erro na tela, com o detalhe do erro capturado
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
    }
  } else {
    // Exibe uma mensagem informando que o preenchimento está incorreto
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preencha todos os campos corretamente.')),
    );
  }
}
