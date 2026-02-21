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

  def buscar_cliente_por_numero_conta(numero_conta)
    @clientes.find { |c| c.conta.numero_conta == numero_conta}
  end

  def login(numero_conta:, senha:)
    cliente = buscar_cliente_por_conta(numero_conta)

    unless cliente
      return { sucesso: false, erro: "Conta não encontrada" }
    end

    unless cliente.autenticador(senha)
      return { sucesso: false, erro: "Senha incorreta" }
    end

    {sucesso: true, cliente: cliente}
  end

  def salvar_dados
    dados = {
      nome: @nome,
      cliente: @cliente.map(&:to_hash)
    }

    File.write(ARQUIVO_DADOS, JSON.pretty_generate(dados))
  end

  def carregar_dados
    return unless File.exist?(ARQUIVO_DADOS)

    dados = JSON.parse(File.read(ARQUIVO_DADOS))

    @CLIENTES = dados['clientes'].map do |hash|
      Cliente.from_hash(hash)
    end
  rescue => e
    puts "Erro ao carregar dados: #{e.message}".colorize(:red)
  end

  def estatisticas
    total_clientes= @clientes.length
    saldo_total =@clientes.sum { |c| c.conta.transacoes.legth }
    total_transacoes = @clientes.sum { |c| c.conta.transacoes.length }

    stats = "\n" + "=" * 60 + "\n"
    stats += "📈 ESTATÍSTICAS DO BANCO #{@nome}".center(60).colorize(:cyan).bold + "\n"
    stats += "=" * 60 + "\n"
    stats += "Total de clientes: #{total_clientes}\n"
    stats += "Saldo total: R$ #{sprintf('%.2f', saldo_total)}".colorize(:green) + "\n"
    stats += "Total de transações: #{total_transacoes}\n"
    stats += "=" * 60
    
    stats
  end
end
