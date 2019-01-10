#!/bin/bash

gym(){
python << END
from gym import envs
from pprint import pprint
# names = [ vars(e) for e in envs.registry.all() ]
names = [ e.id for e in envs.registry.all() ]
pprint(names)
END
}
