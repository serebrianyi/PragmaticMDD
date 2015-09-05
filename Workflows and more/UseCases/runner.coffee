child_process = require('child_process')
console.log "Executing ../Framework/Initial.coffee"
console.log child_process.execSync 'coffee "../Framework/initial.coffee" "../UseCases/custom/initialSetup.coffee"', { encoding: 'utf8' }
console.log "Executing ../Framework/Default/runner.coffee"
console.log child_process.execSync 'coffee "../Framework/Default/runner.coffee" "../../UseCases/custom/defaultSetup.coffee"', { encoding: 'utf8' }
console.log "Executing ../Framework/PojoWithAutoupdate/runner.coffee"
console.log child_process.execSync 'coffee "../Framework/PojoWithAutoupdate/runner.coffee" "../../UseCases/custom/pojoWithAutoupdateSetup.coffee" "../../Framework/Hibernate/hibernateInjector.coffee"', { encoding: 'utf8' }