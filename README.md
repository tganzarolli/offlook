Pra rodar
MONGOID_ENV=development ruby ./syncher.rb
Pra testar
MONGOID_ENV=development rspec ./specs/

Known bugs: Falta implementar as recorrências corretamente. O access token expira depois de alguns minutos.