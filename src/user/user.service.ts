import { ConflictException, Injectable } from '@nestjs/common';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';

@Injectable()
export class UserService {
  prisma: any;
  async create(createUserDto: CreateUserDto) {
    try{
      const usuario = await this.prisma.usuario.create({
        data: {
          ...CreateUserDto,
          create_at: new Date(),
        },
      });
      return usuario;
    } catch (error) {
      if (error.code === 'P2002'){
        throw new ConflictException('El telefono ya está registrado')
      }
    }
  }

  findAll() {
    return `This action returns all user`;
  }

  findOne(id: number) {
    return `This action returns a #${id} user`;
  }

  update(id: number, updateUserDto: UpdateUserDto) {
    return `This action updates a #${id} user`;
  }

  remove(id: number) {
    return `This action removes a #${id} user`;
  }
}
