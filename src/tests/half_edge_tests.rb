# -*- coding: utf-8 -*-
# 
# Author: José Emiliano Cabrera Blancas (jemiliano.cabrera@gmail.com)
#

require File.expand_path(File.join(File.dirname(__FILE__), "../shared_libraries/half_edge"))

#
# Reabre el modulo de Test para agregar las clase TestHalfEdge, la cual
# tiene los test de las funciones de la estructura de C.
#

module Test
  class TestHalfEdge

    # Public: Calcula la intersecion de dos segmentos
    #
    # Examples
    #
    #     Test::TestHalfEdge.self.he_intersection([73.0, 80.0],[6.0, 89.0],
    #                                             [87.0, 96.0],[15.0, 27.0])
    #     # => [70.63574274331246, 80.31758679567444, [[73.0, 80.0], [6.0, 89.0]], [[87.0, 96.0], [15.0, 27.0]]]
    # 
    # Regresa nil en cado de no existir intersecion, en caso contrario regresa el
    # punto donde se intersecta y los segmentos que conforman esas intersecion.
    def self.he_intersection(a,b,c,d)
      a = a.map{|x| x.to_f}
      b = b.map{|x| x.to_f}
      c = c.map{|x| x.to_f}
      d = d.map{|x| x.to_f}

      x1 = a[0]
      y1 = a[1]

      x2 = b[0]
      y2 = b[1]
      
      x3 = c[0]
      y3 = c[1]

      x4 = d[0]
      y4 = d[1]      

      det = (x1-x2)*(y3-y4) - (y1-y2)*(x3-x4);

      return nil if (det == 0)

      xi = ((x3-x4)*(x1*y2-y1*x2)-(x1-x2)*(x3*y4-y3*x4))/det;
      yi = ((y3-y4)*(x1*y2-y1*x2)-(y1-y2)*(x3*y4-y3*x4))/det;
      
      return nil if (xi < [x1,x2].min or xi > [x1,x2].max)
      return nil if (xi < [x3,x4].min or xi > [x3,x4].max)
      
      return [xi,yi,[a,b],[c,d]]
    end    
    
    # Public: Prueba la funcion que copia segmentos que se le pasen.
    #
    # Examples
    #
    #     Test::TestHalfEdge.copy_half_edge
    #     # => true
    # 
    # Regresa true si la funcion en C responde de forma correcta o false en caso 
    # contrario.
    def self.copy_half_edge
      a_x = rand(2**27)
      a_y = rand(2**27)

      b_x = rand(2**27)
      b_y = rand(2**27)
      
      a = Points.init_point(a_x,a_y)
      b = Points.init_point(b_x,b_y)

      half_edge = HalfEdge.init_half_edge(a,b)
      half_edge_copy = HalfEdge.copy_half_edge(half_edge)

      result = half_edge[:first][:x] == half_edge_copy[:first][:x] and
        half_edge[:first][:y] == half_edge_copy[:first][:y] and
        half_edge[:last][:x] == half_edge_copy[:last][:x] and
        half_edge[:last][:y] == half_edge_copy[:last][:y]

      HalfEdge.destroy_half_edge_with_points(half_edge)
      HalfEdge.destroy_half_edge_with_points(half_edge_copy)

      result 
    end

    # Public: Prueba la intersecion de varios segmentos
    #
    # Examples
    #
    #     Test::TestHalfEdge.half_edge_intersection
    #     # => true
    # 
    # Regresa true si la funcion en C responde de forma correcta o false en caso 
    # contrario.

    def self.half_edge_intersection
      number = rand(1000) + 100

      number.times.each do
        
        a = [rand(100), rand(100)]
        b = [rand(100), rand(100)]
        c = [rand(100), rand(100)]
        d = [rand(100), rand(100)]

        raw_intersection = he_intersection(a,b,c,d)

        a_c = Points.init_point(a[0].to_f,a[1].to_f)
        b_c = Points.init_point(b[0].to_f,b[1].to_f)
        c_c = Points.init_point(c[0].to_f,c[1].to_f)
        d_c = Points.init_point(d[0].to_f,d[1].to_f)

        he_a = HalfEdge.init_half_edge(a_c,b_c)
        he_b = HalfEdge.init_half_edge(c_c,d_c)
        
        intersection = HalfEdge.he_intersection(he_a,he_b)
        

        if (raw_intersection.nil?) then
          if not(intersection.null?) then           
            HalfEdge.destroy_half_edge_with_points(he_a)
            HalfEdge.destroy_half_edge_with_points(he_b)
            
            return false
          end
        else
          
          if intersection.null? then
            return false
          end
          
          if (intersection[:x] != raw_intersection[0]) then
            HalfEdge.destroy_half_edge_with_points(he_a)
            HalfEdge.destroy_half_edge_with_points(he_b)
            
            return false
          end
          
          if (intersection[:y] != raw_intersection[1]) then           
            HalfEdge.destroy_half_edge_with_points(he_a)
            HalfEdge.destroy_half_edge_with_points(he_b)

            return false
          end

          if not(intersection[:intersection] == he_a.pointer or 
                 intersection[:half_edge] == he_a.pointer)
            
            HalfEdge.destroy_half_edge_with_points(he_a)
            HalfEdge.destroy_half_edge_with_points(he_b)
            
            return false
          end
          
          if not(intersection[:intersection] == he_b.pointer or 
                 intersection[:half_edge] == he_b.pointer)
            
            HalfEdge.destroy_half_edge_with_points(he_a)
            HalfEdge.destroy_half_edge_with_points(he_b)

            return false
          end
        end
        HalfEdge.destroy_half_edge_with_points(he_a)
        HalfEdge.destroy_half_edge_with_points(he_b)
        
      end

      return true
      
    end
  end
end
