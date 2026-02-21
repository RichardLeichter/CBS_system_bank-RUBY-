require_relative 'cliente'
require_relative 'validador'
require 'json'
require 'colorize'
require 'httparty'

class Banco
  attr_reader :nome, :clientes

  ARQUIVO_DADOS = 'data/clientes.jason'

  def initialize(nome:)
    @nome = nome
    @clientes = []
    carregar_dados
  end

  def cadastrar_cliente(nome:, cpf:, senha:, saldo_inicial: 0.0)
    validacao = Validador.validar_cpf(cpf)
    unless validacao[:valido]
      return { sucesso: false, erro: validacao[:erro] }
    end

    if buscar_cliente_por_cpf(cpf)
      return { sucesso: false, erro: "CPF já cadastrado" }
    end

    validacao = Validador.validar_senha(senha)
    unless validacao[:valido]
      return { sucesso: false, erro: validacao[:erro] }
    end

    cliente = Cliente.new(
      nome: nome,
      cpf: cpf,
      senha: senha,
      saldo_inicial: saldo_inicial
    )
    
    @cliente << cliente
    salvar_dados

    {
      sucesso: true,
      mensagem: "Cliente cadastrado com sucesso!",
      numero_conta: cliente.conta.numero_conta
    }
  end

  def buscar_cliente_por_cpf(cpf)
    cpf_limpo = cpf.gsub(/\D/, '')
    @clientes.find { |c| c.cpf == cpf_limpo}
  end
    

